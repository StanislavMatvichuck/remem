//
//  EventExtensions.swift
//  Application
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Domain
import Foundation

public enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    public static func make(_ date: Date) -> WeekDay {
        WeekDay(rawValue: Calendar.current.dateComponents([.weekday], from: date).weekday!)!
    }
}

/// must be replaced buy `DateDayIndex` -> for what? why?
/// but very carefully with attention to each code refactoring
/// trying not to break existing tests
struct DayComponents: Equatable, CustomDebugStringConvertible {
    public let date: Date
    public let value: DateComponents
    /// is a computed property and used only for comparison
    /// only 2 places in code that use `value`

    /// can be deleted?
    public init(date: Date) {
        self.date = date
        value = Calendar.current.dateComponents([.year, .month, .day], from: date)
    }

    /// can be deleted
    public var europeanWeekDay: WeekDay { WeekDay.make(date) }

    /// can be deleted
    public var debugDescription: String { "\(date.debugDescription) \(value.debugDescription)" }

    /// this is implemented already better
    public static func == (lhs: DayComponents, rhs: DayComponents) -> Bool {
        return lhs.value == rhs.value
    }

    /// heavily used by tests
    public static let referenceValue: DayComponents = {
        let referenceDay = DateComponents(year: 2001, month: 1, day: 1)
        let referenceDate = Calendar.current.date(from: referenceDay)!
        let day = DayComponents(date: referenceDate)
        return day
    }()

    /// heavily used by tests
    /// used in WeekViewModel
    public func adding(components: DateComponents) -> DayComponents {
        DayComponents(date: Calendar.current.date(byAdding: components, to: date)!)
    }
}

extension Event {
    func happenings(forDayComponents day: DayComponents) -> [Happening] {
        let startOfDay = Calendar.current.startOfDay(for: day.date)
        let startOfDayComponents = Calendar.current.dateComponents([.year, .month, .day], from: startOfDay)

        var endOfDayComponents = startOfDayComponents
        endOfDayComponents.hour = 23
        endOfDayComponents.minute = 59
        endOfDayComponents.second = 59

        guard let endOfDayDate = Calendar.current.date(from: endOfDayComponents) else { return [] }

        return happenings.filter {
            $0.dateCreated >= startOfDay &&
                $0.dateCreated < endOfDayDate
        }
    }
}
