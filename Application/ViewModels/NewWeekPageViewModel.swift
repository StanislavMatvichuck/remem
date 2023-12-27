//
//  NewWeekPageViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

struct NewWeekPageViewModel {
    static let daysCount: Int = 7
    static let weekNumberDescription = String(localized: "newWeek.weekNumberDescription")
    static let totalNumberDescription = String(localized: "newWeek.totalNumberDescription")
    static let localisedDaysNames = {
        let formatter = DateFormatter()
        var days = formatter.veryShortWeekdaySymbols!
        return Array(days[1 ..< days.count]) + days[0 ..< 1]
    }()

    private let event: Event
    private let dayFactory: NewWeekDayViewModelFactoring
    private let pageIndex: Int
    private let today: Date

    init(event: Event, dayFactory: NewWeekDayViewModelFactoring, pageIndex: Int, today: Date) {
        self.event = event
        self.dayFactory = dayFactory
        self.pageIndex = pageIndex
        self.today = today
        self.weekMaximumHappeningsCount = {
            var maximum = 0

            for dayNumber in 0 ..< Self.daysCount {
                let dayIndex = dayNumber + pageIndex * 7
                let day = WeekIndex(event.dateCreated).dayIndex.adding(days: dayIndex)
                let dayHappeningsAmount = event.happenings(forDayIndex: day).count

                if maximum < dayHappeningsAmount { maximum = dayHappeningsAmount }
            }

            return maximum
        }()
    }

    let weekMaximumHappeningsCount: Int

    var weekNumber: Int {
        let from = WeekIndex(event.dateCreated).date
        let to = WeekIndex(today).date
        let weeksDifference = Calendar.current.dateComponents(
            [.weekOfYear],
            from: from,
            to: to
        ).weekOfYear ?? 0

        return weeksDifference + 1
    }

    var totalNumber: Int { event.happeningsAmount(forWeekAt: today) }

    var title: String {
        Self.weekNumberDescription +
            " \(weekNumber) " +
            Self.totalNumberDescription +
            " \(totalNumber)"
    }

    var localisedMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: today)
        return nameOfMonth
    }

    func day(for index: Int) -> NewWeekDayViewModel {
        dayFactory.makeNewWeekDayViewModel(
            index: index,
            pageIndex: pageIndex,
            weekMaximum: weekMaximumHappeningsCount
        )
    }
}
