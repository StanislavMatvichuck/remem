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
            $0.dateCreated >= startOfDay && $0.dateCreated < endOfDayDate
        }
    }

    /// Calculates start of week, end of week and filters all event happenings
    /// - Parameter date: date may be not normalised
    /// - Returns: amount of happenings that fits between start and end of week
    func happeningsAmount(forWeekAt date: Date) -> Int {
        let startOfWeek = WeekIndex(date)
        var endOfWeekComponents = Calendar.current.dateComponents([.year, .month, .day], from: startOfWeek.dayIndex.adding(days: 6).date)
        endOfWeekComponents.hour = 23
        endOfWeekComponents.minute = 59
        endOfWeekComponents.second = 59

        guard let endOfWeekDate = Calendar.current.date(from: endOfWeekComponents) else { return 0 }

        return happenings.filter {
            let isLaterThanStartOfWeek = $0.dateCreated >= startOfWeek.date
            let isEarlierThanEndOfWeek = $0.dateCreated < endOfWeekDate
            return isLaterThanStartOfWeek && isEarlierThanEndOfWeek
        }.count
    }
}
