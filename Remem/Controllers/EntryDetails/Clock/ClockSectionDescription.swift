//
//  ClockSectionDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockSectionDescription: Equatable {
    enum VisualVariant: Int {
        case empty
        case little
        case mid
        case big

        static func make(from: Int) -> VisualVariant {
            if let stitch = VisualVariant(rawValue: from) {
                return stitch
            } else {
                return .big
            }
        }
    }

    var pointsAmount: Int = 0
    var hasFreshPoint: Bool = false
    var variant: Self.VisualVariant { .make(from: pointsAmount) }
}

// MARK: - Public
extension ClockSectionDescription {
    mutating func addPoint() { pointsAmount += 1 }
    mutating func setHasLastPoint() { hasFreshPoint = true }
}
