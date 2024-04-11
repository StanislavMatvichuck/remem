//
//  GoalsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Domain
import UIKit

final class GoalsContainer:
    GoalsViewModelFactoring,
    GoalViewModelFactoring
{
    private let parent: EventDetailsContainer
    private let repository = TemporaryGoalsRepository()
    private var event: Event { parent.event }
    private var now: Date { parent.currentMoment }

    init(_ parent: EventDetailsContainer) {
        self.parent = parent
    }

    func make() -> UIViewController { GoalsViewController(factory: self) }

    // MARK: - ViewModels

    func makeGoalsViewModel() -> GoalsViewModel {
        GoalsViewModel(cells: [
            .goals: repository.get(for: event).map { makeGoalViewModel(goal: $0) },
            .createGoal: [makeCreateGoalViewModel()]
        ])
    }

    func makeGoalViewModel(goal: Goal) -> GoalViewModel {
        GoalViewModel(
            goal: goal,
            incrementCommand: makeIncrementCommand(goal: goal),
            decrementCommand: makeDecrementCommand(goal: goal)
        )
    }

    func makeCreateGoalViewModel() -> CreateGoalViewModel {
        CreateGoalViewModel(command: makeCreateCommand())
    }

    // MARK: - Handlers
    func makeIncrementCommand(goal: Goal) -> GoalIncrementCommand {
        GoalIncrementCommand(goal: goal, repository: repository)
    }

    func makeDecrementCommand(goal: Goal) -> GoalDecrementCommand {
        GoalDecrementCommand(goal: goal, repository: repository)
    }

    func makeCreateCommand() -> GoalCreateCommand {
        GoalCreateCommand(
            repository: repository,
            date: .now,
            count: event.happenings.count + 1,
            event: event
        )
    }
}

final class TemporaryGoalsRepository: GoalsQuerying, GoalsCommanding {
    private var goals: [Goal] = []

    func get(for _: Domain.Event) -> [Domain.Goal] { goals }

    func save(_ goal: Domain.Goal) {
        if let index = goals.firstIndex(where: { existingGoal in
            existingGoal.id == goal.id
        }) {
            goals[index] = goal
        } else {
            goals.append(goal)
        }
    }

    func remove(_: Domain.Goal) {}
}
