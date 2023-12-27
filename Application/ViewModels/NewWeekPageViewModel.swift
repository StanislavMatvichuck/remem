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
    private let index: Int
    private let today: Date

    init(event: Event, dayFactory: NewWeekDayViewModelFactoring, index: Int, today: Date) {
        self.event = event
        self.dayFactory = dayFactory
        self.index = index
        self.today = today
        self.weekMaximumHappeningsCount = {
            var maximum = 0

            for dayNumber in 0 ..< Self.daysCount {
                let dayIndex = dayNumber + index * 7
                let day = DayIndex(event.dateCreated).adding(days: dayIndex)
                let dayHappeningsAmount = event.happenings(forDayIndex: day).count
                if maximum < dayHappeningsAmount {
                    maximum = dayHappeningsAmount
                }
            }

            return maximum
        }()
    }

    let weekMaximumHappeningsCount: Int

    var weekNumber: Int {
        let from = event.dateCreated
        let weeksDifference = Calendar.current.dateComponents([.weekOfMonth], from: from, to: today).weekOfMonth ?? 0
        return weeksDifference + 1
    }

    var totalNumber: Int {
        event.happeningsAmount(forWeekAt: today)
    }

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
            pageIndex: self.index,
            weekMaximum: weekMaximumHappeningsCount
        )
    }
}
