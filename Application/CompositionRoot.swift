//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

class CompositionRoot: CoordinatingFactory {
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinating
    let eventsListViewModelUpdater: EventsListViewModelUpdateDispatcher
    let dayViewModelUpdater: DayViewModelUpdateDispatcher
    let clockViewModelUpdater: ClockViewModelUpdateDispatcher

    init() {
        let coordinator = DefaultCoordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(
                inMemory: false
            ),
            mapper: EventEntityMapper()
        )

        let decoratedEventsProviderCommander = EventsCommandingEventsListViewModelUpdatingDecorator(
            decoratedInterface: repository
        )

        let decoratedEventsListViewModelUpdatingDecorator = EventsCommandingDayViewModelUpdatingDecorator(
            decoratedInterface: decoratedEventsProviderCommander
        )

        let decoratedClockViewModelUpdatingDecorator = EventsCommandingClockViewModelUpdatingDecorator(
            decoratedInterface: decoratedEventsListViewModelUpdatingDecorator
        )

        self.coordinator = coordinator
        self.provider = repository
        self.commander = decoratedClockViewModelUpdatingDecorator
        self.eventsListViewModelUpdater = decoratedEventsProviderCommander
        self.dayViewModelUpdater = decoratedEventsListViewModelUpdatingDecorator
        self.clockViewModelUpdater = decoratedClockViewModelUpdatingDecorator

        decoratedEventsProviderCommander.viewModelFactory = makeEventsListViewModel
        decoratedEventsListViewModelUpdatingDecorator.viewModelFactory = makeDayViewModel
        decoratedClockViewModelUpdatingDecorator.viewModelFactory = makeClockViewModel
        coordinator.factory = self
    }

    // MARK: - Controllers creation
    func makeController(for navCase: CoordinatingCase) -> UIViewController {
        switch navCase {
        case .list: return makeEventsListViewController()
        case .eventItem(let event): return makeEventViewController(event)
        case .weekItem(let day, let event): return makeDayViewController(event, day)
        }
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(.list)
        return coordinator.root
    }

    func makeEventsListViewController() -> EventsListViewController {
        let eventsListController = EventsListViewController(viewModel: makeEventsListViewModel())
        eventsListViewModelUpdater.addUpdateReceiver(eventsListController)
        return eventsListController
    }

    func makeEventsListViewModel() -> EventsListViewModel {
        EventsListViewModel(
            events: provider.get(),
            today: DayComponents(date: .now),
            itemViewModelFactory: makeEventItemViewModel,
            commander: commander
        )
    }

    func makeEventItemViewModel(
        event: Event,
        today: DayComponents
    ) -> EventItemViewModel {
        EventItemViewModel(
            event: event,
            today: today,
            coordinator: coordinator,
            commander: commander
        )
    }

    func makeEventViewController(_ event: Domain.Event) -> EventViewController {
        EventViewController(
            event: event,
            commander: commander,
            controllers: [
                makeWeekViewController(
                    event: event,
                    coordinator: coordinator
                ),
                makeClockViewController(event: event),
            ]
        )
    }

    func makeWeekViewController(
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
        let controller = ClockViewController(viewModel: makeClockViewModel(event: event))
        clockViewModelUpdater.addUpdateReceiver(controller)
        return controller
    }

    func makeClockViewModel(event: Event) -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func makeDayViewController(_ event: Event, _ day: DayComponents) -> DayViewController {
        let viewModel = makeDayViewModel(event: event, day: day)
        let controller = DayViewController(viewModel: viewModel)
        dayViewModelUpdater.addUpdateReceiver(controller)
        return controller
    }

    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(day: day, event: event, commander: commander)
    }
}
