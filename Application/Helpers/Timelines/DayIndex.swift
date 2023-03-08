//
//  DateIndex.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

struct DayIndex: DateIndexing {
    public let date: Date

    public init(_ date: Date) {
        self.date = calendar.startOfDay(for: date)
    }
}

extension DayIndex {
    func adding(days: Int) -> DayIndex {
        DayIndex(calendar.date(byAdding: DateComponents(day: days), to: date)!)
    }
}

extension WeekIndex {
    var dayIndex: DayIndex { DayIndex(date) }
}
