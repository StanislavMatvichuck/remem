//
//  HourDistributionCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Foundation

struct HourDistributionCellViewModel {
    let relativeLength: CGFloat = 0
    let hours: String

    init(_ index: Int) {
        hours = {
            switch index {
            case 0: "00"
            case 1: "01"
            case 2: "02"
            case 3: "03"
            case 4: "04"
            case 5: "05"
            case 6: "06"
            case 7: "07"
            case 8: "08"
            case 9: "09"
            case 10 ... 23: "\(index)"
            default: fatalError("index must be under 23")
            }
        }()
    }
}
