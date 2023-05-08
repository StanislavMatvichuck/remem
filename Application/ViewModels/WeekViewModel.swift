//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

struct WeekViewModel {
    typealias GoalChangeHandler = (Int, Date) -> Void
    private let today: DayIndex
    private let event: Event

    let goalChangeHander: GoalChangeHandler
    var scrollToIndex: Int = 0
    var timeline: DayTimeline<WeekCellViewModel>
    var pages: WeekTimeline<EventWeeklyGoalViewModel>

    init(
        today: DayIndex,
        event: Event,
        itemFactory: WeekItemViewModelFactoring,
        goalChangeHandler: @escaping GoalChangeHandler
    ) {
        self.today = today
        self.event = event
        goalChangeHander = goalChangeHandler

        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let startOfWeekToday = WeekIndex(today.date).dayIndex
        let endOfWeekToday = startOfWeekToday.adding(days: 7)

        timeline = DayTimeline<WeekCellViewModel>(
            storage: [:],
            startIndex: startOfWeek,
            endIndex: endOfWeekToday
        )

        for i in 0 ..< timeline.count {
            let nextDay = startOfWeek.adding(days: i)

            if nextDay == startOfWeekToday { scrollToIndex = i }

            timeline[nextDay] = itemFactory.makeViewModel(day: nextDay)
        }

        pages = WeekTimeline(
            storage: [:],
            startIndex: WeekIndex(startOfWeek.date),
            endIndex: WeekIndex(endOfWeekToday.date)
        )

        var summaryCountingTimeline: WeekTimeline<Int> = WeekTimeline(
            storage: [:],
            startIndex: WeekIndex(startOfWeek.date),
            endIndex: WeekIndex(endOfWeekToday.date)
        )

        for weekIndex in summaryCountingTimeline.indices {
            summaryCountingTimeline[weekIndex] = event.happeningsAmount(forWeekAt: weekIndex.date)
        }

        for index in summaryCountingTimeline.indices {
            pages[index] = EventWeeklyGoalViewModel(
                weekDate: index.date,
                event: event,
                goalEditable: startOfWeekToday == index.dayIndex
            )
        }
    }
}
