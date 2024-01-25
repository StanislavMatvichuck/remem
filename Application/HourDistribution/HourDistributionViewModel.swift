//
//  HourDistributionViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Domain
import Foundation

struct HourDistributionViewModel {
    let count: Int = 24
    let valueTotal: Int

    private let cellsValues: [Int]

    init(_ happenings: [Happening] = []) {
        var cellsValues = Array(repeating: 0, count: count)

        for happening in happenings {
            let hour = Calendar.current.dateComponents([.hour], from: happening.dateCreated).hour!
            cellsValues[hour] += 1
        }

        self.cellsValues = cellsValues
        self.valueTotal = cellsValues.max() ?? 0
    }

    func cell(at index: Int) -> HourDistributionCellViewModel {
        HourDistributionCellViewModel(
            index,
            valueTotal: valueTotal,
            value: cellsValues[index]
        )
    }
}
