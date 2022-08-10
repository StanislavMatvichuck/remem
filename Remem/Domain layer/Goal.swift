//
//  Goal.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 10.08.2022.
//

import Foundation

struct Goal: Equatable {
    enum WeekDay: Int, CaseIterable {
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        case sunday = 1

        static func make(_ date: Date) -> WeekDay {
            WeekDay(rawValue: Calendar.current.dateComponents([.weekday], from: date).weekday!)!
        }
    }

    let amount: Int
    let event: Event
    let dateCreated: Date
    var dateRemoved: Date?
}   
