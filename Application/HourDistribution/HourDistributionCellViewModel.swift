//
//  HourDistributionCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Foundation

struct HourDistributionCellViewModel {
    let relativeLength: CGFloat
    let hours: String
    let isHidden: Bool

    init(_ index: Int, valueTotal: Int = 0, value: Int = 0) {
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

        relativeLength = value == 0 ? 0 : CGFloat(value) / CGFloat(valueTotal)
        isHidden = value == 0
    }
}
