//
//  DayOfWeekViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2024.
//

import Domain
import Foundation

struct DayOfWeekViewModel {
    let count: Int = 7
    let valueTotal: Int

    private let cellsValues: [Int]
    private let currentMoment: Date?
    private var currentDayIndex: Int? {
        if let currentMoment,
           let weekDayFromCalendar = Calendar.current.dateComponents(
               [.weekday],
               from: currentMoment
           ).weekday
        { return [6, 0, 1, 2, 3, 4, 5][weekDayFromCalendar - 1] }
        return nil
    }

    init(_ happenings: [Happening] = [], currentMoment: Date? = nil) {
        var cellsValues = Array(repeating: 0, count: count)

        for happening in happenings {
            let weekIndex = WeekIndex(happening.dateCreated)
            let happeningDayOfWeekOffset = Calendar.current.dateComponents(
                [.day],
                from: weekIndex.date,
                to: happening.dateCreated
            ).day!
            cellsValues[happeningDayOfWeekOffset] += 1
        }

        self.cellsValues = cellsValues
        self.valueTotal = cellsValues.max() ?? 0
        self.currentMoment = currentMoment
    }

    func cell(at index: Int) -> DayOfWeekCellViewModel {
        DayOfWeekCellViewModel(
            index,
            value: cellsValues[index],
            valueTotal: valueTotal,
            isToday: currentDayIndex == index
        )
    }
}
