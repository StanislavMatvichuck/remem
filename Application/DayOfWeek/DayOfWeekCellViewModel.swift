//
//  DayOfWeekCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.01.2024.
//

import Domain
import Foundation

struct DayOfWeekCellViewModel {
    let shortDayName: String
    let percent: CGFloat
    let value: Int
    let isHidden: Bool

    init(_ index: Int, value: Int = 0, valueTotal: Int = 0) {
        self.value = value
        self.percent = value == 0 ? 0 : CGFloat(value) / CGFloat(valueTotal)
        self.isHidden = value == 0

        let date = DayIndex.referenceValue.adding(days: index).date
        self.shortDayName = date.formatted(Date.FormatStyle().weekday(.narrow))
    }
}
