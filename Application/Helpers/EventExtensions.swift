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

extension Event {
    func happenings(forDayIndex day: DayIndex) -> [Happening] {
        let startOfDay = Calendar.current.startOfDay(for: day.date)
        let startOfDayIndex = Calendar.current.dateComponents([.year, .month, .day], from: startOfDay)

        var endOfDayIndex = startOfDayIndex
        endOfDayIndex.hour = 23
        endOfDayIndex.minute = 59
        endOfDayIndex.second = 59

        guard let endOfDayDate = Calendar.current.date(from: endOfDayIndex) else { return [] }

        return happenings.filter {
            $0.dateCreated >= startOfDay &&
                $0.dateCreated < endOfDayDate
        }
    }
}
