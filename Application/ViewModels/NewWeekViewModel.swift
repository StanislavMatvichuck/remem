//
//  NewWeekViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2023.
//

import Domain
import Foundation

struct NewWeekViewModel {
    static let weekNumberDescription = String(localized: "newWeek.weekNumberDescription")
    static let totalNumberDescription = String(localized: "newWeek.totalNumberDescription")
    static let localisedDaysNames = {
        let formatter = DateFormatter()
        var days = formatter.veryShortWeekdaySymbols!
        return Array(days[1..<days.count]) + days[0..<1]
    }()

    private let event: Event
    private let dayFactory: NewWeekDayViewModelFactoring

    init(event: Event, dayFactory: NewWeekDayViewModelFactoring) {
        self.event = event
        self.dayFactory = dayFactory
    }

    func weekNumber(forToday today: Date) -> Int {
        let calendar = Calendar.current
        let from = event.dateCreated
        let weeksDifference = calendar.dateComponents([.weekOfMonth], from: from, to: today).weekOfMonth ?? 0
        return weeksDifference + 1
    }

    func totalNumber(forToday today: Date) -> Int {
        event.happeningsAmount(forWeekAt: today)
    }

    func title(forToday today: Date) -> String {
        Self.weekNumberDescription +
            " \(weekNumber(forToday: today)) " +
            Self.totalNumberDescription +
            " \(totalNumber(forToday: today))"
    }

    func localisedMonth(forToday today: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: today)
        return nameOfMonth
    }

    /// Days visible amount
    /// - Parameter today: first visible day
    /// - Returns: amount that is divided by seven
    func daysCount(forToday today: Date) -> Int {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let startOfWeekToday = WeekIndex(today).dayIndex
        let endOfWeekToday = startOfWeekToday.adding(days: 7)

        let calendar = Calendar.current
        let daysDifference = calendar.dateComponents([.day], from: startOfWeek.date, to: endOfWeekToday.date).day ?? 0

        return daysDifference
    }

    /// Used by UICollectionView in NewWeekView
    /// - Parameter index: days distance from start of the week of event creation
    /// - Returns: cell that describe day of the week
    func day(at index: IndexPath) -> NewWeekDayViewModel? {
        dayFactory.makeNewWeekDayViewModel(index: index.row)
    }
}
