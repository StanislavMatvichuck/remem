//
//  Goal.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Foundation

public class Goal {
    public let id: String
    public let dateCreated: Date
    public var value: GoalValue
    public var achieved: Bool { progress >= 1.0 }

    public let event: Event
    public var contributingHappeningsCount: Int {
        var count = 0

        for happening in event.happenings {
            /// cut all happenings that created before goal
            if happening.dateCreated < dateCreated { continue }
            count += 1
        }

        return count
    }

    public init(
        id: String = UUID().uuidString,
        dateCreated: Date,
        value: GoalValue = GoalValue(),
        event: Event
    ) {
        self.id = id
        self.dateCreated = dateCreated
        self.value = value
        self.event = event
    }

    public var progress: CGFloat {
        let count = contributingHappeningsCount
        return count == 0 ? 0 : CGFloat(count) / CGFloat(value.amount)
    }

    public var leftToAchieve: Int {
        let leftToAchieve = Int(value.amount) - contributingHappeningsCount
        return leftToAchieve > 0 ? leftToAchieve : 0
    }

    public var achievedAt: Date? {
        var achievedAt: Date?
        var countedHappenings = 0

        for happening in event.happenings {
            /// cut all happenings that created before goal
            if happening.dateCreated < dateCreated { continue }

            countedHappenings += 1

            /// first happening that achieves goal
            if countedHappenings >= value.amount, achievedAt == nil {
                achievedAt = happening.dateCreated
            }
        }

        return achievedAt
    }

    public func update(value: Int) { self.value = GoalValue(amount: value) }
}

public struct GoalValue: Equatable {
    public let amount: Int32
    public init(amount: Int = 1) {
        if amount > 1 {
            self.amount = Int32(amount)
        } else {
            self.amount = 1
        }
    }
}
