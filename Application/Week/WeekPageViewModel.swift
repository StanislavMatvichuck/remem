//
//  WeekPageViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

struct WeekPageViewModel {
    static let daysCount: Int = 7
    static let weekNumberDescription = String(localized: "Week.weekNumberDescription")
    static let totalNumberDescription = String(localized: "Week.totalNumberDescription")

    private let event: Event
    private let dayFactory: WeekDayViewModelFactoring
    private let pageIndex: Int
    private let lastDayStart: Date
    private let dailyMaximum: Int

    init(
        event: Event,
        dayFactory: WeekDayViewModelFactoring,
        pageIndex: Int,
        dailyMaximum: Int
    ) {
        self.event = event
        self.dayFactory = dayFactory
        self.pageIndex = pageIndex
        self.dailyMaximum = dailyMaximum

        let startWeekIndex = WeekIndex(event.dateCreated)
        let endOfWeekIndex = startWeekIndex.dayIndex.adding(days: pageIndex * 7)
        self.lastDayStart = endOfWeekIndex.date
    }

    var weekNumber: Int {
        let from = WeekIndex(event.dateCreated).date
        let to = WeekIndex(lastDayStart).date
        let weeksDifference = Calendar.current.dateComponents(
            [.weekOfYear],
            from: from,
            to: to
        ).weekOfYear ?? 0

        return weeksDifference + 1
    }

    var totalNumber: Int { event.happeningsAmount(forWeekAt: lastDayStart) }

    var title: String {
        Self.weekNumberDescription +
            " \(weekNumber) " +
            Self.totalNumberDescription +
            " \(totalNumber)"
    }

    var localisedMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: lastDayStart)
        return nameOfMonth
    }

    func day(dayNumberInWeek: Int) -> WeekDayViewModel {
        dayFactory.makeWeekDayViewModel(
            dayIndex: pageIndex * 7 + dayNumberInWeek,
            dailyMaximum: dailyMaximum
        )
    }
}
