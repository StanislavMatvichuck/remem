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

    init(_ index: Int, value: Int = 0, valueTotal: Int = 0) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 0

        self.value = "\(value)"

        let calculatedPercent = CGFloat(value) / CGFloat(valueTotal)
        let readablePercent = formatter.string(from: calculatedPercent as NSNumber)

        self.percent = value == 0 ? "\(0)" : readablePercent!
        self.isHidden = value == 0

        let date = DayIndex.referenceValue.adding(days: index).date
        self.shortDayName = date.formatted(Date.FormatStyle().weekday(.narrow))
    }
}
