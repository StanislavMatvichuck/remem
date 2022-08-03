//
//  WeekDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

struct WeekDay {
    var amount: Int = 0
    let date: DateComponents
}

// MARK: - Public
extension WeekDay {
    var isToday: Bool {
        let calendar = Calendar.current
        if let date = calendar.date(from: date) {
            return calendar.isDateInToday(date)
        } else { return false }
    }

    var dayNumber: Int {
        return date.day ?? 0
    }
}
