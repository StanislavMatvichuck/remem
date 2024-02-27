//
//  Goal.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Foundation

public struct Goal {
    public let dateCreated: Date
    public let value: Int32
    public let progress: CGFloat
    public let leftToAchieve: Int
    public var achieved: Bool { progress >= 1.0 }
    public var achievedAt: Date?

    private let event: Event

    public init(
        dateCreated: Date,
        value: Int32,
        event: Event
    ) {
        self.dateCreated = dateCreated
        self.value = value
        self.event = event

        var countedHappenings = 0
        var achievedAt: Date?

        for happening in event.happenings {
            /// cut all happenings that created before goal
            if happening.dateCreated < dateCreated { continue }

            countedHappenings += 1

            /// first happening that achieves goal
            if countedHappenings >= value, achievedAt == nil {
                achievedAt = happening.dateCreated
            }
        }

        self.achievedAt = achievedAt

        if countedHappenings != 0 {
            let progress = CGFloat(countedHappenings) / CGFloat(value)
            self.progress = progress
        } else {
            self.progress = 0
        }

        let leftToAchieve = Int(value) - countedHappenings
        self.leftToAchieve = leftToAchieve > 0 ? leftToAchieve : 0
    }
}
