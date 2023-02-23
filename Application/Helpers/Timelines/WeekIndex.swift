//
//  DateWeekIndex.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Domain
import Foundation

struct WeekIndex {
    public let date: Date

    public init(_ date: Date) {
        let startOfDay = calendar.startOfDay(for: date)
        let startOfWeek = {
            var prevStartOfDay = startOfDay

            while WeekDay.make(prevStartOfDay) != .monday {
                let oneNegativeDay = DateComponents(day: -1)
                prevStartOfDay = calendar.date(byAdding: oneNegativeDay, to: prevStartOfDay)!
            }

            return prevStartOfDay
        }()

        self.date = startOfWeek
    }
}

extension WeekIndex: Comparable {
    public static func == (lhs: WeekIndex, rhs: WeekIndex) -> Bool {
        return lhs.date == rhs.date
    }

    public static func < (lhs: WeekIndex, rhs: WeekIndex) -> Bool {
        return lhs.date.compare(rhs.date) == .orderedAscending
    }
}

extension WeekIndex: CustomDebugStringConvertible {
    public var debugDescription: String {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "MMMM d"
            return f
        }()

        return dateFormatter.string(from: date)
    }
}
