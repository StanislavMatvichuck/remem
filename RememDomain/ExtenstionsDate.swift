//
//  DateExtenstions.swift
//  RememDomain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

import Foundation

public extension Date {
    //
    // Stack overflow helpers
    //

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    private func isEqual(to date: Date,
                         toGranularity component: Calendar.Component,
                         in calendar: Calendar = .current) -> Bool
    {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    ///
    /// StackOverflow
    ///
    /// might have issues with American calendar

    var startOfWeek: Date? {
        let c = Calendar.current
        var weekComponents = c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        weekComponents.hour = 0
        weekComponents.minute = 0
        weekComponents.second = 0
        guard let monday = c.date(from: weekComponents) else { return nil }
        return c.date(byAdding: .day, value: 0, to: monday)
    }

    var endOfWeek: Date? {
        let c = Calendar.current
        var weekComponents = c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        weekComponents.hour = 23
        weekComponents.minute = 59
        weekComponents.second = 59
        guard let monday = c.date(from: weekComponents) else { return nil }
        return c.date(byAdding: .day, value: 6, to: monday)
    }

    var endOfDay: Date? {
        let c = Calendar.current
        var dayComponents = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        dayComponents.hour = 23
        dayComponents.minute = 59
        dayComponents.second = 59
        guard let endOfDay = c.date(from: dayComponents) else { return nil }
        return endOfDay
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

// MARK: - StackOverflow helpers
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }

    var dayByDayWeekForward: StrideTo<Date> {
        return stride(from: days(ago: -7), to: self, by: 60 * 60 * 24)
    }
}
