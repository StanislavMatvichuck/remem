//
//  EntensionPoint.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.01.2022.
//

import Foundation

enum DayOfWeek: Int {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    var string: String {
        return "\(rawValue)"
    }
}

extension Point {
    var time: String {
        guard let date = dateCreated else { return "time" }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium

        let dateString = formatter.string(from: date)

        return dateString
    }

    var timeSince: String {
        guard let date = dateCreated else { return "-" }
        
        return date.timeAgoDisplay()
    }

    var dow: DayOfWeek {
        guard let date = dateCreated else { return .monday }

        let dayOfWeek = DayOfWeek(rawValue: Calendar.current.dateComponents([.weekday], from: date).weekday!)!

        return dayOfWeek
    }
}
