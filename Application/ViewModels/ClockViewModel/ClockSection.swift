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
    public var variant: Self.VisualVariant { .make(from: happeningsAmount) }

    public init() {}
}

// MARK: - Public
public extension ClockSection {
    mutating func addHappening() { happeningsAmount += 1 }
}
