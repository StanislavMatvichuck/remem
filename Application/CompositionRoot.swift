//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

class CompositionRoot {
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinating
    let eventsListUpdater: EventsListsUpdater

    init() {
        let updater = EventsListsUpdater()
        let coordinator = DefaultCoordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(
                inMemory: false
            ),
            mapper: EventEntityMapper()
        )

        let decoratedEventsProviderCommander = EventsRepositoryDecorator(
            decoratee: repository,
            updater: updater
        )

        self.coordinator = coordinator
        self.eventsListUpdater = updater
        self.provider = repository
        self.commander = decoratedEventsProviderCommander

        decoratedEventsProviderCommander.viewModelFactory = makeEventsListViewModel
    }

    // MARK: - Controllers creation

    func makeRootViewController() -> UIViewController {
        let viewModel = makeEventsListViewModel()
        let eventsListController = EventsListViewController(viewModel: viewModel)
        coordinator.show(eventsListController)
        eventsListUpdater.addDelegate(eventsListController)
        return eventsListController.navigationController!
    }

    func makeEventsListViewModel() -> EventsListViewModel {
        EventsListViewModel(
            events: provider.get(),
            today: DayComponents(date: .now),
            onAdd: { name in
                self.commander.save(Event(name: name))
            },
            itemViewModelFactory: makeEventItemViewModel
        )
    }

    func makeEventItemViewModel(
        event: Event,
        today: DayComponents
    ) -> EventItemViewModel {
        EventItemViewModel(
            event: event,
            today: today,
            onSelect: { event in
                self.coordinator.show(self.makeEventController(event: event))
            },
            coordinator: coordinator,
            commander: commander
        )
    }

    func makeEventController(event: Event) -> EventViewController {
        EventViewController(
            event: event,
            commander: commander,
            controllers: [
                makeWeekController(
                    event: event,
                    coordinator: coordinator
                ),
                makeClockViewController(event: event),
            ]
        )
    }

    func makeWeekController(
        event: Event,
        coordinator: Coordinating
    ) -> WeekViewController {
        WeekViewController(
            today: DayComponents(date: .now),
            event: event,
            commander: commander,
            coordinator: coordinator
        )
    }

    func makeClockViewController(event: Event) -> ClockViewController {
        ClockViewController(
            event: event,
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func makeDayController(day: DayComponents, event: Event) -> DayViewController {
        DayViewController(
            day: day,
            event: event,
            commander: commander
        )
    }
}

class EventsRepositoryDecorator: EventsCommanding {
    let decoratee: EventsCommanding
    let updater: EventsListViewModelUpdating
    var viewModelFactory: (() -> EventsListViewModel)?

    init(
        decoratee: EventsCommanding,
        updater: EventsListViewModelUpdating
    ) {
        self.decoratee = decoratee
        self.updater = updater
    }

    func save(_ event: Domain.Event) {
        decoratee.save(event)
        sendUpdates()
    }

    func delete(_ event: Domain.Event) {
        decoratee.delete(event)
        sendUpdates()
    }

    private func sendUpdates() {
        guard let viewModelFactory else { return }
        updater.update(viewModel: viewModelFactory())
    }
}

protocol EventsListViewModelUpdating { func update(viewModel: EventsListViewModel) }

class EventsListsUpdater:
    MulticastDelegate<EventsListViewModelUpdating>,
    EventsListViewModelUpdating
{
    func update(viewModel: EventsListViewModel) {
        call { $0.update(viewModel: viewModel) }
    }
}
