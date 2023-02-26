//
//  EventDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol EventDetailsContainerFactoring {
    func makeContainer(event: Event, today: DayIndex) -> EventDetailsContainer
}

final class EventDetailsContainer {
    let coordinator: DefaultCoordinator
    let event: Event
    let today: DayIndex
    let clockViewModelUpdater: Updater<ClockViewController, ClockViewModelFactory>
    let weekViewModelUpdater: Updater<WeekViewController, WeekViewModelFactory>
    let summaryViewModelUpdater: Updater<SummaryViewController, SummaryViewModelFactory>

    lazy var weekFactory: WeekViewModelFactory = {
        WeekViewModelFactory(
            today: today,
            event: event,
            coordinator: coordinator,
            itemFactory: self
        )
    }()

    lazy var summaryFactory: SummaryViewModelFactory = {
        SummaryViewModelFactory(event: event, today: today)
    }()

    lazy var clockFactory: ClockViewModelFactory = {
        ClockViewModelFactory(event: event)
    }()

    init(
        event: Event,
        today: DayIndex,
        commander: EventsCommanding,
        coordinator: DefaultCoordinator
    ) {
        self.event = event
        self.today = today
        self.coordinator = coordinator

        let clockUpdater = Updater<ClockViewController, ClockViewModelFactory>(commander)
        let summaryUpdater = Updater<SummaryViewController, SummaryViewModelFactory>(clockUpdater)
        let weekUpdater = Updater<WeekViewController, WeekViewModelFactory>(summaryUpdater)

        self.clockViewModelUpdater = clockUpdater
        self.summaryViewModelUpdater = summaryUpdater
        self.weekViewModelUpdater = weekUpdater

        coordinator.dayDetailsFactory = self
        clockViewModelUpdater.factory = clockFactory
        summaryViewModelUpdater.factory = summaryFactory
        weekViewModelUpdater.factory = weekFactory
    }

    func makeController() -> EventDetailsViewController {
        EventDetailsViewController(
            viewModel: makeViewModel(),
            controllers: [
                makeWeekViewController(),
                makeClockViewController(),
                makeSummaryViewController()
            ]
        )
    }

    func makeWeekViewController() -> WeekViewController {
        let controller = WeekViewController(viewModel: weekFactory.makeViewModel())
        weekViewModelUpdater.delegate = controller
        return controller
    }

    func makeClockViewController() -> ClockViewController {
        let controller = ClockViewController(viewModel: clockFactory.makeViewModel())
        clockViewModelUpdater.delegate = controller
        return controller
    }

    func makeSummaryViewController() -> SummaryViewController {
        let controller = SummaryViewController(viewModel: summaryFactory.makeViewModel())
        summaryViewModelUpdater.delegate = controller
        return controller
    }
}

extension EventDetailsContainer: DayDetailsContainerFactoring {
    func makeContainer(day: DayIndex) -> DayDetailsContainer {
        DayDetailsContainer(
            event: event,
            day: day,
            commander: weekViewModelUpdater
        )
    }
}

// MARK: - ViewModelFactoring
protocol EventViewModelFactoring { func makeViewModel() -> EventDetailsViewModel }
protocol WeekItemViewModelFactoring { func makeViewModel(day: DayIndex) -> WeekItemViewModel }

extension EventDetailsContainer:
    EventViewModelFactoring,
    WeekItemViewModelFactoring
{
    func makeViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(
            event: event,
            commander: weekViewModelUpdater
        )
    }

    func makeViewModel(day: DayIndex) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            coordinator: coordinator
        )
    }
}

struct WeekViewModelFactory: ViewModelFactoring {
    let today: DayIndex
    let event: Event
    let coordinator: DefaultCoordinator
    let itemFactory: WeekItemViewModelFactoring

    func makeViewModel() -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            coordinator: coordinator,
            itemFactory: itemFactory
        )
    }
}

struct SummaryViewModelFactory: ViewModelFactoring {
    let event: Event
    let today: DayIndex
    func makeViewModel() -> SummaryViewModel { SummaryViewModel(event: event, today: today) }
}

struct ClockViewModelFactory: ViewModelFactoring {
    let event: Event

    func makeViewModel() -> ClockViewModel {
        ClockViewModel(
            event: event,
            sorter: DefaultClockSorter(size: 144)
        )
    }
}
