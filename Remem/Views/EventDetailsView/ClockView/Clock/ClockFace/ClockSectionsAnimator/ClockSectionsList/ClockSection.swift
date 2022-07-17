//
//  ClockSectionDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockSection: Equatable {
    enum VisualVariant: Int {
        case empty
        case little
        case mid
        case big

        static func make(from: Int) -> VisualVariant {
            if let section = VisualVariant(rawValue: from) {
                return section
            } else {
                return .big
            }
        }
    }

    var happeningsAmount: Int = 0
    var hasFreshHappening: Bool = false
    var isToday: Bool = false
    var variant: Self.VisualVariant { .make(from: happeningsAmount) }
}

// MARK: - Public
extension ClockSection {
    mutating func addHappening() { happeningsAmount += 1 }
    mutating func setHasLastHappening() { hasFreshHappening = true }
    mutating func setToday() { isToday = true }
}
