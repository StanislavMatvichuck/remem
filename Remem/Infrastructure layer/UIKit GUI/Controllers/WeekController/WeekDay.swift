//
//  WeekDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

struct WeekDay {
    let goal: Goal?
    let happenings: [Happening]
    let date: Date
}

// MARK: - Public
extension WeekDay {
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }

    var dayNumber: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }
}
