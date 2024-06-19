//
//  WeekDay.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 21.04.2023.
//

import Foundation

public enum WeekDay: Int, CaseIterable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1

    // TODO: remove unsafe init
    public static func make(_ date: Date) -> WeekDay {
        WeekDay(rawValue: Calendar.current.dateComponents([.weekday], from: date).weekday!)!
    }

    public init?(date: Date) {
        if let weekDay = Calendar.current.dateComponents([.weekday], from: date).weekday {
            self.init(rawValue: weekDay)
        } else {
            return nil
        }
    }

    public init(index: Int) { switch index {
    case 0: self = .monday
    case 1: self = .tuesday
    case 2: self = .wednesday
    case 3: self = .thursday
    case 4: self = .friday
    case 5: self = .saturday
    case 6: self = .sunday
    default: fatalError("invalid index")
    } }

    public var index: Int { switch self {
    case .monday: 0
    case .tuesday: 1
    case .wednesday: 2
    case .thursday: 3
    case .friday: 4
    case .saturday: 5
    case .sunday: 6
    } }

    public var shortName: String { Calendar.current.shortWeekdaySymbols[rawValue - 1] }
}
