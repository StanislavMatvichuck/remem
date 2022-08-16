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
    var dateDisabled: Date?
}

// MARK: - Public
extension Goal {
    func isReached(at date: Date) -> Bool {
        let filteredHappenings = event.happenings.filter { h in
            h.dateCreated.isInSameDay(as: date)
        }

        let happeningsTotalValue = filteredHappenings.reduce(0) { partialResult, h in
            partialResult + h.value
        }

        return happeningsTotalValue >= amount && dateDisabled == nil
    }
}
