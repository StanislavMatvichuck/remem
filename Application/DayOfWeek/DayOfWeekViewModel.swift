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

    init(_ happenings: [Happening] = []) {
        self.valueTotal = happenings.count
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
    }

    func cell(at index: Int) -> DayOfWeekCellViewModel {
        DayOfWeekCellViewModel(
            index,
            value: cellsValues[index],
            valueTotal: valueTotal
        )
    }
}
