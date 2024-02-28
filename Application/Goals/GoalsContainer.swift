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
    private var controller: Updating?

    func make() -> UIViewController {
        let controller = GoalsViewController(factory: self)
        self.controller = controller
        return controller
    }

    func makeGoalsViewModel() -> GoalsViewModel {
        GoalsViewModel(cells: goals, createGoalTapHandler: makeCreateEventCellTapHandler())
    }

    func makeGoalViewModel() -> GoalViewModel {
        GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            value: Int32(goals.count),
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
        ))
    }

    // MARK: - Handlers
    func makeCreateEventCellTapHandler() -> GoalsViewModel.CreateButtonTapHandler {{
        self.goals.append(self.makeGoalViewModel())
        self.controller?.update()
        print(#function)
    }}
}
