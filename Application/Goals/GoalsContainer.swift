//
//  GoalsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Domain
import UIKit

final class GoalsContainer:
    ControllerFactoring,
    GoalsViewModelFactoring,
    GoalViewModelFactoring
{
    private var goals: [GoalViewModel] = []
    private let parent: EventDetailsContainer
    private var updater: Updating { parent.updater }
    private var event: Event { parent.event }
    private var now: Date { parent.currentMoment }

    init(_ parent: EventDetailsContainer) {
        self.parent = parent
    }

    func make() -> UIViewController {
        let controller = GoalsViewController(factory: self)
        parent.updater.addDelegate(controller)
        return controller
    }

    // MARK: - ViewModels

    func makeGoalsViewModel() -> GoalsViewModel {
        GoalsViewModel(cells: [
            .goals: goals,
            .createGoal: [makeCreateGoalViewModel()]
        ])
    }

    func makeGoalViewModel() -> GoalViewModel {
        GoalViewModel(goal: Goal(
            dateCreated: now,
            value: GoalValue(amount: goals.count),
            event: event
        ))
    }

    func makeCreateGoalViewModel() -> CreateGoalViewModel {
        CreateGoalViewModel(handler: makeCreateGoalTapHandler())
    }

    // MARK: - Handlers
    func makeCreateGoalTapHandler() -> CreateGoalViewModel.TapHandler {{
        self.goals.append(self.makeGoalViewModel())
        self.updater.update()
        print(#function)
    }}
}
