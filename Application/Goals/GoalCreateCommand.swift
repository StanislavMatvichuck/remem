//
//  GoalCreateCommand.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.03.2024.
//

import Domain
import Foundation

struct GoalCreateCommand: Command {
    let repository: GoalsCommanding
    let updater: Updating
    let date: Date
    let count: Int
    let event: Event

    func execute() {
        let createdGoal = Goal(dateCreated: date, event: event)
        repository.save(createdGoal)
        updater.update()
    }
}
