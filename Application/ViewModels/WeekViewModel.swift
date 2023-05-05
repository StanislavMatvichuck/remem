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
    var pages: WeekTimeline<WeekViewModelPage>

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

        // Summaries

        var summaryCountingTimeline: WeekTimeline<Int> = WeekTimeline(
            storage: [:],
            startIndex: WeekIndex(startOfWeek.date),
            endIndex: WeekIndex(endOfWeekToday.date)
        )

        for weekIndex in summaryCountingTimeline.indices {
            let amount = event.happeningsAmount(forWeekAt: weekIndex.date)
            summaryCountingTimeline[weekIndex] = amount
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "= "

        // Pages

        for index in summaryCountingTimeline.indices {
            let sum = summaryCountingTimeline[index] ?? 0
            let sumString = String(summaryCountingTimeline[index] ?? 0)
            let goalAmount = event.weeklyGoalAmount(at: index.date)
            let progress = CGFloat(sum) / CGFloat(goalAmount)
            let progressString = formatter.string(from: progress as NSNumber)

            let newPage = WeekViewModelPage(
                sum: sumString,
                goal: goalAmount == 0 ? nil : String(goalAmount),
                percentage: goalAmount == 0 ? nil : progressString,
                progress: progress,
                goalEditable: startOfWeekToday == index.dayIndex
            )

            pages[index] = newPage
        }
    }
}
