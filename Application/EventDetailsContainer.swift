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
    }

    func makeController() -> EventViewController {
        let controller = EventViewController(
            viewModel: makeEventViewModel(event: event),
            controllers: [
                WeekViewController(viewModel: makeWeekViewModel(event: event, today: today)),
                ClockViewController(viewModel: makeClockViewModel(event: event))
            ]
        )
        return controller
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
}

// MARK: - ViewModelFactoring
extension EventDetailsContainer:
    ClockViewModelFactoring,
    EventViewModelFactoring,
    WeekViewModelFactoring,
    WeekItemViewModelFactoring
{
    func makeClockViewModel(event: Event) -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144),
            selfFactory: self
        )
    }

    func makeEventViewModel(event: Event) -> EventViewModel {
        EventViewModel(
            event: event,
            commander: weekViewModelUpdater,
            selfFactory: self
        )
    }

    func makeWeekViewModel(event: Event, today: DayComponents) -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: parent.parent.coordinator,
            itemsFactory: self,
            selfFactory: self
        )
    }

    func makeWeekItemViewModel(
        event: Event,
        today: DayComponents,
        day: DayComponents
    ) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: parent.parent.coordinator
        )
    }
}

extension EventDetailsContainer: DayDetailsContainerFactoring {
    func makeContainer(event: Event, day: DayComponents) -> DayDetailsContainer {
        DayDetailsContainer(parent: self, event: event, day: day)
    }
}
