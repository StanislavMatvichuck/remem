//
//  Goal.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
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

    public static func make(_ date: Date) -> WeekDay {
        WeekDay(rawValue: Calendar.current.dateComponents([.weekday], from: date).weekday!)!
    }
}

public struct Goal: Equatable {
    public let amount: Int
    public let dateCreated: Date
}
