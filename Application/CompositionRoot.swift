//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

class CompositionRoot:
    CoordinatingFactory,
    EventItemViewModelFactoring,
    DayItemViewModelFactoring
{
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinating
    let eventsListViewModelUpdater: EventsListViewModelUpdateDispatcher
    let dayViewModelUpdater: DayViewModelUpdateDispatcher
    let clockViewModelUpdater: ClockViewModelUpdateDispatcher
    let weekViewModelUpdater: WeekViewModelUpdateDispatcher

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

        let decoratedWeekViewModelUpdatingDecorator = EventsCommandingWeekViewModelUpdatingDecorator(
            decoratedInterface: decoratedClockViewModelUpdatingDecorator
        )

        self.coordinator = coordinator
        self.provider = repository
        self.commander = decoratedWeekViewModelUpdatingDecorator
        self.eventsListViewModelUpdater = decoratedEventsProviderCommander
        self.dayViewModelUpdater = decoratedEventsListViewModelUpdatingDecorator
        self.clockViewModelUpdater = decoratedClockViewModelUpdatingDecorator
        self.weekViewModelUpdater = decoratedWeekViewModelUpdatingDecorator

        decoratedEventsProviderCommander.viewModelFactory = makeEventsListViewModel
        decoratedEventsListViewModelUpdatingDecorator.viewModelFactory = makeDayViewModel
        decoratedClockViewModelUpdatingDecorator.viewModelFactory = makeClockViewModel
        decoratedWeekViewModelUpdatingDecorator.viewModelFactory = makeWeekViewModel
        coordinator.factory = self
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(.list)
        return coordinator.root
    }

    // MARK: - Controllers creation
    func makeController(for navCase: CoordinatingCase) -> UIViewController {
        switch navCase {
        case .list: return makeEventsListViewController()
        case .eventItem(let today, let event): return makeEventViewController(event, today)
        case .weekItem(let day, let event): return makeDayViewController(event, day)
        }
    }

    func makeEventsListViewController() -> EventsListViewController {
        let eventsListController = EventsListViewController(viewModel: makeEventsListViewModel())
        eventsListViewModelUpdater.addUpdateReceiver(eventsListController)
        return eventsListController
    }

    func makeEventViewController(_ event: Domain.Event, _ today: DayComponents) -> EventViewController {
        EventViewController(
            viewModel: makeEventViewModel(event: event),
            controllers: [
                makeWeekViewController(
                    event: event,
                    today: today
                ),
                makeClockViewController(event: event),
            ]
        )
    }

    func makeWeekViewController(event: Event, today: DayComponents) -> WeekViewController {
        let controller = WeekViewController(viewModel: makeWeekViewModel(event: event, today: today))
        weekViewModelUpdater.addUpdateReceiver(controller)
        return controller
    }

    func makeClockViewController(event: Event) -> ClockViewController {
        let controller = ClockViewController(viewModel: makeClockViewModel(event: event))
        clockViewModelUpdater.addUpdateReceiver(controller)
        return controller
    }

    func makeDayViewController(_ event: Event, _ day: DayComponents) -> DayViewController {
        let viewModel = makeDayViewModel(event: event, day: day)
        let controller = DayViewController(viewModel: viewModel)
        dayViewModelUpdater.addUpdateReceiver(controller)
        return controller
    }

    // MARK: - ViewModels creation
    func makeEventsListViewModel() -> EventsListViewModel {
        EventsListViewModel(
            events: provider.get(),
            today: DayComponents(date: .now),
            factory: self,
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

    func makeClockViewModel(event: Event) -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func makeEventViewModel(event: Event) -> EventViewModel {
        EventViewModel(event: event, commander: commander)
    }

    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(
            day: day,
            event: event,
            commander: commander,
            factory: self
        )
    }

    func makeDayItemViewModel(event: Event, happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: commander
        )
    }

    func makeWeekViewModel(event: Event, today: DayComponents) -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: coordinator,
            commander: commander
        )
    }
}
