//
//  HourDistributionViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Foundation

struct HourDistributionViewModel {
    let count: Int = 24

    func cell(at index: Int) -> HourDistributionCellViewModel {
        HourDistributionCellViewModel(index)
    }
}
