//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

protocol WeekViewModelFactoring {
    func makeWeekViewModel(
        event: Event,
        today: DayComponents
    ) -> WeekViewModel
}

protocol WeekItemViewModelFactoring {
    func makeWeekItemViewModel(
        event: Event,
        today: DayComponents,
        day: DayComponents
    ) -> WeekItemViewModel
}

struct WeekViewModel: EventDependantViewModel {
    private let upcomingWeeksCount = 3
    private let today: DayComponents
    private let commander: EventsCommanding
    private let coordinator: DefaultCoordinator
    private var event: Event
    private let itemsFactory: WeekItemViewModelFactoring
    private let selfFactory: WeekViewModelFactoring

    var items: [WeekItemViewModel]
    var scrollToIndex: Int = 0
    var eventId: String /// used by `WeekViewModelUpdating`

    init(
        today: DayComponents,
        event: Event,
        coordinator: DefaultCoordinator,
        commander: EventsCommanding,
        itemsFactory: WeekItemViewModelFactoring,
        selfFactory: WeekViewModelFactoring
    ) {
        self.today = today
        self.event = event
        self.coordinator = coordinator
        self.commander = commander
        self.itemsFactory = itemsFactory
        self.selfFactory = selfFactory
        eventId = event.id

        let startOfWeekDayCreated = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: event.dateCreated
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayComponents(date: date)
        }()

        let startOfWeekDayToday = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: today.date
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayComponents(date: date)
        }()

        let weeksBetweenTodayAndEventCreationDay: Int = {
            let amount = Calendar.current.dateComponents(
                [.weekOfYear],
                from: event.dateCreated,
                to: today.date
            ).weekOfYear ?? 0
            return max(0, amount)
        }()

        let daysToShow = (weeksBetweenTodayAndEventCreationDay + upcomingWeeksCount) * 7

        var viewModels = [WeekItemViewModel]()

        for addedDay in 0 ..< daysToShow {
            let cellDay = startOfWeekDayCreated.adding(components: DateComponents(day: addedDay))
            let vm = itemsFactory.makeWeekItemViewModel(
                event: event,
                today: today,
                day: cellDay
            )

            viewModels.append(vm)

            if cellDay == startOfWeekDayToday {
                scrollToIndex = addedDay
            }
        }

        items = viewModels
    }

    func copy(newEvent: Event) -> WeekViewModel {
        selfFactory.makeWeekViewModel(event: newEvent, today: today)
    }
}
