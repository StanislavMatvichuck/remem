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
    private let coordinator: Coordinator
    private let event: Event

    var scrollToIndex: Int = 0
    var timeline: DayTimeline<WeekItemViewModel>
    var summaryTimeline: WeekTimeline<Int>

    init(
        today: DayIndex,
        event: Event,
        coordinator: Coordinator,
        itemFactory: AnyObject & WeekItemViewModelFactoring
    ) {
        self.today = today
        self.event = event
        self.coordinator = coordinator

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

        summaryTimeline = WeekTimeline(
            storage: [:],
            startIndex: WeekIndex(startOfWeek.date),
            endIndex: WeekIndex(endOfWeekToday.date)
        )

        for happening in event.happenings {
            let index = WeekIndex(happening.dateCreated)

            if let summaryValue = summaryTimeline[index] {
                summaryTimeline[index] = summaryValue + Int(happening.value)
            } else {
                summaryTimeline[index] = 1
            }
        }
    }
}
