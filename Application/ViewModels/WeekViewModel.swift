//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

struct WeekViewModel {
    private let upcomingWeeksCount = 3
    private let today: DayIndex
    private let coordinator: DefaultCoordinator
    private let event: Event

    let items: [WeekItemViewModel]
    let itemFactory: WeekItemViewModelFactoring
    var scrollToIndex: Int = 0

    init(
        today: DayIndex,
        event: Event,
        coordinator: DefaultCoordinator,
        itemFactory: WeekItemViewModelFactoring
    ) {
        self.today = today
        self.event = event
        self.coordinator = coordinator
        self.itemFactory = itemFactory

        /// Items creation logic

        let startOfWeekDayCreated = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: event.dateCreated
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayIndex(date)
        }()

        let startOfWeekDayToday = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: today.date
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayIndex(date)
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
            let day = DateComponents(day: addedDay)
            let cellDay = calendar.date(byAdding: day, to: startOfWeekDayCreated.date)!
            let vm = itemFactory.makeViewModel(day: DayIndex(cellDay))

            viewModels.append(vm)

            if cellDay == startOfWeekDayToday.date {
                scrollToIndex = addedDay
            }
        }

        items = viewModels
    }
}
