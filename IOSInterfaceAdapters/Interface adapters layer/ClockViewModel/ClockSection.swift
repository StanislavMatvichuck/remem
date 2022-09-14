//
//  ClockSectionDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

public struct ClockSection: Equatable {
    public enum VisualVariant: Int {
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

    public var happeningsAmount: Int = 0
    public var hasFreshHappening: Bool = false
    public var isToday: Bool = false
    public var variant: Self.VisualVariant { .make(from: happeningsAmount) }

    public init() {}
}

// MARK: - Public
public extension ClockSection {
    mutating func addHappening() { happeningsAmount += 1 }
    mutating func setHasLastHappening() { hasFreshHappening = true }
    mutating func setToday() { isToday = true }
}
