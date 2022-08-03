//
//  EntensionHappening.swift
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

    var europeanDayOfWeek: Int {
        switch self {
        case .sunday: return 7
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        }
    }
}

extension CDHappening {
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
}
