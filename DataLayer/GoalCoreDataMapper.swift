//
//  GoalEntityMapper.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 13.04.2024.
//

import CoreData
import Domain

public enum GoalCoreDataMapper {
    public static func make(for event: Event, cdGoal: CDGoal) -> Goal { Goal(
        id: cdGoal.uuid!,
        dateCreated: cdGoal.dateCreated!,
        value: GoalValue(amount: Int(cdGoal.value)),
        event: event
    ) }

    public static func update(cdGoal: CDGoal, with goal: Goal, cdEvent: CDEvent) {
        cdGoal.uuid = goal.id
        cdGoal.dateCreated = goal.dateCreated
        cdGoal.value = goal.value.amount
        cdGoal.event = cdEvent
    }
}
