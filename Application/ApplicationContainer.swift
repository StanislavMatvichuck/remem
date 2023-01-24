//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import UIKit

class ApplicationContainer:
    CoordinatingFactoring,
    ClockViewModelFactoring,
    DayViewModelFactoring,
    DayItemViewModelFactoring,
    EventViewModelFactoring,
    WeekViewModelFactoring,
    WeekItemViewModelFactoring
{
    let provider: EventsQuerying
    let commander: EventsCommanding
    let coordinator: Coordinating

    let dayViewModelUpdater: DayUpdater
    let clockViewModelUpdater: ClockUpdater
    let weekViewModelUpdater: WeekUpdater

    init(testingInMemoryMode: Bool = false) {
        let coordinator = DefaultCoordinator()
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(inMemory: testingInMemoryMode),
            mapper: EventEntityMapper()
        )

        let dayUpdater = DayUpdater(decoratedInterface: repository)
        let clockUpdater = ClockUpdater(decoratedInterface: dayUpdater)
        let weekUpdater = WeekUpdater(decoratedInterface: clockUpdater)

        self.dayViewModelUpdater = dayUpdater
        self.clockViewModelUpdater = clockUpdater
        self.weekViewModelUpdater = weekUpdater

        self.coordinator = coordinator
        self.provider = repository
        self.commander = weekUpdater

        coordinator.factory = self
    }

    func makeRootViewController() -> UIViewController {
        coordinator.show(.list)
        return coordinator.root
    }

    // MARK: - Controllers creation
    func makeController(for navCase: CoordinatingCase) -> UIViewController {
        switch navCase {
        case .list:
            let container = EventsListContainer(applicationContainer: self)
            return container.makeEventsListViewController(events: provider.get())
        case .eventItem(let today, let event): return makeEventViewController(event, today)
        case .weekItem(let day, let event): return makeDayViewController(event, day)
        }
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
        weekViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    func makeClockViewController(event: Event) -> ClockViewController {
        let controller = ClockViewController(viewModel: makeClockViewModel(event: event))
        clockViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    func makeDayViewController(_ event: Event, _ day: DayComponents) -> DayViewController {
        let viewModel = makeDayViewModel(event: event, day: day)
        let controller = DayViewController(viewModel: viewModel)
        dayViewModelUpdater.addReceiver(receiver: controller)
        return controller
    }

    // MARK: - ViewModels creation

    func makeClockViewModel(event: Event) -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144),
            selfFactory: self
        )
    }

    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel {
        DayViewModel(
            day: day,
            event: event,
            commander: commander,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeEventViewModel(event: Event) -> EventViewModel {
        EventViewModel(
            event: event,
            commander: commander,
            selfFactory: self
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
            commander: commander,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeWeekItemViewModel(event: Event, today: DayComponents, day: DayComponents) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: coordinator
        )
    }
}
