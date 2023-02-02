//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

struct WeekViewModel {
    private let today: DayIndex
    private let coordinator: DefaultCoordinator
    private let event: Event

    let itemFactory: WeekItemViewModelFactoring
    var scrollToIndex: Int = 0
    var timeline: DayTimeline<WeekItemViewModel>

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

        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let startOfWeekToday = WeekIndex(today.date).dayIndex
        let endOfWeekToday = startOfWeekToday.adding(days: 14)

        timeline = DayTimeline<WeekItemViewModel>(
            storage: [:],
            startIndex: startOfWeek,
            endIndex: endOfWeekToday
        )

        for i in 0 ..< timeline.count {
            let nextDay = startOfWeek.adding(days: i)

            if nextDay == startOfWeekToday { scrollToIndex = i }

            timeline[nextDay] = itemFactory.makeViewModel(day: nextDay)
        }
    }
}
