//
//  DateIndex.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

let calendar = Calendar.current

/// passes some tests
struct DayIndex {
    public let date: Date

    public init(_ date: Date) {
        self.date = calendar.startOfDay(for: date)
    }
}

extension DayIndex: Comparable {
    public static func == (lhs: DayIndex, rhs: DayIndex) -> Bool {
        return lhs.date == rhs.date
    }

    public static func < (lhs: DayIndex, rhs: DayIndex) -> Bool {
        return lhs.date.compare(rhs.date) == .orderedAscending
    }
}

extension DayIndex: CustomDebugStringConvertible {
    var debugDescription: String {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "MMMM d"
            return f
        }()

        return dateFormatter.string(from: self.date)
    }
}
