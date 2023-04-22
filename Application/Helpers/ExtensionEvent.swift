//
//  EventExtensions.swift
//  Application
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Domain
import Foundation

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
