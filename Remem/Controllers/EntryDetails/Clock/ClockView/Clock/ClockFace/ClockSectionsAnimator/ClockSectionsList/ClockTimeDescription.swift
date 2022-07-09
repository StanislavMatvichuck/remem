//
//  ClockTimeDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockTimeDescription {
    let hour: Int
    let minute: Int
    let second: Int
}

extension ClockTimeDescription {
    init(date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        hour = components.hour ?? 0
        minute = components.minute ?? 0
        second = components.second ?? 0
    }

    var seconds: Int { hour * 60 * 60 + minute * 60 + second }

    static func makeStartOfDay() -> ClockTimeDescription { ClockTimeDescription(hour: 0, minute: 0, second: 0) }
    static func makeMidday() -> ClockTimeDescription { ClockTimeDescription(hour: 12, minute: 0, second: 0) }
    static func makeEndOfDay() -> ClockTimeDescription { ClockTimeDescription(hour: 24, minute: 0, second: 0) }
}
