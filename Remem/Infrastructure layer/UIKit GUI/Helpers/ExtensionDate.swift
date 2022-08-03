//
//  ExtensionDate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.02.2022.
//

import Foundation

extension Date {
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

    ///
    /// StackOverflow
    ///
    /// might have issues with american calendar

    var startOfWeek: Date? {
        let c = Calendar(identifier: .iso8601)
        var weekComponents = c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        weekComponents.hour = 0
        weekComponents.minute = 0
        weekComponents.second = 0
        guard let monday = c.date(from: weekComponents) else { return nil }
        return c.date(byAdding: .day, value: 0, to: monday)
    }

    var endOfWeek: Date? {
        let c = Calendar(identifier: .iso8601)
        var weekComponents = c.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        weekComponents.hour = 23
        weekComponents.minute = 59
        weekComponents.second = 59
        guard let monday = c.date(from: weekComponents) else { return nil }
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

// MARK: - StackOverflow helpers
extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}
