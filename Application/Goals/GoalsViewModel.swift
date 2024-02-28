//
//  GoalsViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Foundation

struct GoalsViewModel {
    typealias CreateButtonTapHandler = () -> Void

    static let createGoal = String(localizationId: "goals.create")

    let cells: [GoalViewModel]
    private let createGoalTapHandler: CreateButtonTapHandler?

    init(cells: [GoalViewModel] = [], createGoalTapHandler: CreateButtonTapHandler? = nil) {
        self.cells = cells
        self.createGoalTapHandler = createGoalTapHandler
    }

    func handleCreateTap() { createGoalTapHandler?() }
}
