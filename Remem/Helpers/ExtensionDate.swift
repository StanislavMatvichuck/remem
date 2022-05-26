//
//  ExtensionDate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.02.2022.
//

import Foundation

extension Date {
    var weekdayNumber: DayOfWeek {
        DayOfWeek(rawValue: Calendar.current.dateComponents([.weekday], from: self).weekday!)!
    }

    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    //
    // Stack overflow helpers
    //

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear: Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek: Bool { isInSameWeek(as: Date()) }

    var isInYesterday: Bool { Calendar.current.isDateInYesterday(self) }
    var isInToday: Bool { Calendar.current.isDateInToday(self) }
    var isInTomorrow: Bool { Calendar.current.isDateInTomorrow(self) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast: Bool { self < Date() }

    ///
    /// StackOverflow
    ///
		/// might have issues with american calendar

    var startOfWeek: Date? {
        let c = Calendar.current
        guard let monday = c.date(from: c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        else { return nil }
        return c.date(byAdding: .day, value: 0, to: monday)
    }

    var endOfWeek: Date? {
        let c = Calendar.current
        guard let monday = c.date(from: c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        else { return nil }
        return c.date(byAdding: .day, value: 6, to: monday)
    }

    ///
    /// Remem methods
    ///

    func days(ago: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -ago, to: self)!
    }

    static let yesterday: Date = { Date.now.days(ago: 1) }()
    static let beforeYesterday: Date = { Date.now.days(ago: 2) }()
    static let weekAgo: Date = { Date.now.days(ago: 7) }()
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)

        return numberOfDays.day! + 1
    }
}
