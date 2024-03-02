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
            dateCreated: DayIndex.referenceValue.date,
            value: Int32(goals.count),
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
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
