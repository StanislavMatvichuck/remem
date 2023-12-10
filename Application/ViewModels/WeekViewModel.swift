//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

struct WeekViewModel {
    typealias GoalChangeHandler = (Int) -> Void
    private let today: DayIndex
    private let event: Event

    let goalChangeHandler: GoalChangeHandler
    // TODO: hide access to arrays and indexes
    var timelineVisibleIndex: Int = 0
    var timeline: DayTimeline<WeekCellViewModel>

    var pagesVisibleIndex: Int { timelineVisibleIndex / 7 }
    var pages: WeekTimeline<WeekSummaryViewModel>

    init(
        today: DayIndex,
        event: Event,
        weekCellFactory: WeekCellViewModelFactoring,
        weekSummaryFactory: WeekSummaryViewModelFactoring,
        visibleDayIndex: Int?,
        goalChangeHandler: @escaping GoalChangeHandler
    ) {
        self.today = today
        self.event = event
        self.goalChangeHandler = goalChangeHandler

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

            if nextDay == startOfWeekToday { timelineVisibleIndex = i }

            timeline[nextDay] = weekCellFactory.makeViewModel(day: nextDay)
        }

        pages = WeekTimeline(
            storage: [:],
            startIndex: WeekIndex(startOfWeek.date),
            endIndex: WeekIndex(endOfWeekToday.date)
        )

        for i in 0 ..< pages.count {
            let nextWeek = WeekIndex(WeekIndex(event.dateCreated).dayIndex.adding(days: 7 * i).date)
            pages[nextWeek] = weekSummaryFactory.makeViewModel(today: today, week: nextWeek)
        }

        if let visibleDayIndex {
            timelineVisibleIndex = visibleDayIndex
        }
    }
}
