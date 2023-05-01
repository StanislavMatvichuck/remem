//
//  DateIndex.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

public struct DayIndex: DateIndexing {
    public let date: Date

    public init(_ date: Date) {
        self.date = Calendar.current.startOfDay(for: date)
    }

    public func adding(days: Int) -> DayIndex {
        DayIndex(Calendar.current.date(byAdding: DateComponents(day: days), to: date)!)
    }
}

public extension WeekIndex {
    var dayIndex: DayIndex { DayIndex(date) }
}
