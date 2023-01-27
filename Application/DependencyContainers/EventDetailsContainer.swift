//
//  EventDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol EventDetailsContainerFactoring {
    func makeContainer(event: Event, today: DayComponents) -> EventDetailsContainer
}

final class EventDetailsContainer {
    let parent: EventsListContainer
    let event: Event
    let today: DayComponents
    let clockViewModelUpdater: ClockUpdater
    let weekViewModelUpdater: WeekUpdater

    init(parent: EventsListContainer, event: Event, today: DayComponents) {
        self.parent = parent
        self.event = event
        self.today = today
        let updater = ClockUpdater(decoratedInterface: parent.updater)
        self.clockViewModelUpdater = updater
        self.weekViewModelUpdater = WeekUpdater(decoratedInterface: updater)
        parent.parent.coordinator.dayDetailsFactory = self
        clockViewModelUpdater.factory = self
        weekViewModelUpdater.factory = self
    }

    func makeController() -> EventDetailsViewController {
        EventDetailsViewController(
            viewModel: makeViewModel(),
            controllers: [
                makeWeekViewController(),
                makeClockViewController()
            ]
        )
    }

    func makeWeekViewController() -> WeekViewController {
        let controller = WeekViewController(viewModel: makeViewModel())
        weekViewModelUpdater.add(receiver: controller)
        return controller
    }

    func makeClockViewController() -> ClockViewController {
        let controller = ClockViewController(viewModel: makeViewModel())
        clockViewModelUpdater.add(receiver: controller)
        return controller
    }
}

protocol EventViewModelFactoring { func makeViewModel() -> EventDetailsViewModel }
protocol WeekViewModelFactoring { func makeViewModel() -> WeekViewModel }
protocol WeekItemViewModelFactoring { func makeViewModel(day: DayComponents) -> WeekItemViewModel }
protocol ClockViewModelFactoring { func makeViewModel() -> ClockViewModel }

// MARK: - ViewModelFactoring
extension EventDetailsContainer:
    ClockViewModelFactoring,
    EventViewModelFactoring,
    WeekViewModelFactoring,
    WeekItemViewModelFactoring
{
    func makeViewModel() -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func makeViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(
            event: event,
            commander: weekViewModelUpdater
        )
    }

    func makeViewModel() -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: parent.parent.coordinator,
            itemFactory: self
        )
    }

    func makeViewModel(day: DayComponents) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: parent.parent.coordinator
        )
    }
}

protocol DayDetailsContainerFactoring {
    func makeContainer(day: DayComponents) -> DayDetailsContainer
}

extension EventDetailsContainer: DayDetailsContainerFactoring {
    func makeContainer(day: DayComponents) -> DayDetailsContainer {
        DayDetailsContainer(parent: self, event: event, day: day)
    }
}
