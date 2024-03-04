//
//  GoalIncrementUseCase.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.03.2024.
//

import Domain

struct GoalIncrementCommand: Command {
    let goal: Goal
    let repository: GoalsCommanding
    let updater: Updating

    func execute() {
        goal.update(value: Int(goal.value.amount) + 1)
        repository.save(goal)
        updater.update()
    }
}
