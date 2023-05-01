//
//  DateWeekIndex.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

public struct WeekIndex: DateIndexing {
    public let date: Date

    public init(_ date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let startOfWeek = {
            var prevStartOfDay = startOfDay

            while WeekDay.make(prevStartOfDay) != .monday {
                let oneNegativeDay = DateComponents(day: -1)
                prevStartOfDay = Calendar.current.date(byAdding: oneNegativeDay, to: prevStartOfDay)!
            }

            return prevStartOfDay
        }()

        self.date = startOfWeek
    }
}
