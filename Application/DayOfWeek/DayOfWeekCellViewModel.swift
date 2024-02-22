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
    let percent: String
    let value: String
    let isHidden: Bool
    let relativeLength: CGFloat
    let isToday: Bool

    init(
        _ index: Int,
        value: Int = 0,
        valueTotal: Int = 0,
        isToday: Bool = false
    ) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 0

        self.value = "\(value)"

        let calculatedPercent = value == 0 ? 0 : CGFloat(value) / CGFloat(valueTotal)
        let readablePercent = formatter.string(from: calculatedPercent as NSNumber)

        self.percent = readablePercent!
        self.isHidden = value == 0
        self.relativeLength = calculatedPercent
        self.isToday = isToday

        let date = DayIndex.referenceValue.adding(days: index).date
        self.shortDayName = date.formatted(Date.FormatStyle().weekday(.narrow))
    }
}
