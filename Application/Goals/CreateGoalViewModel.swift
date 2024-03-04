//
//  CreateGoalViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import Foundation

struct CreateGoalViewModel {
    static let createGoal = String(localizationId: "goals.create")

    let command: GoalCreateCommand?

    init(command: GoalCreateCommand? = nil) { self.command = command }
}
