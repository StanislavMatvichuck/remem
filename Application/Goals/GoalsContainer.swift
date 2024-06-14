//
//  GoalsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import DataLayer
import Domain
import UIKit

final class GoalsContainer:
    GoalsControllerFactoring,
    GoalsViewModelFactoring,
    GoalViewModelFactoring,
    UpdateGoalServiceFactoring
{
    private let parent: EventDetailsContainer

    init(_ parent: EventDetailsContainer) {
        self.parent = parent
    }

    func makeGoalsController() -> GoalsController {
        let list = GoalsView.makeList()
        return GoalsController(
            factory: self,
            view: makeGoalsView(list: list),
            dataSource: makeDataSource(list: list)
        )
    }

    func makeGoalsView(list: UICollectionView) -> GoalsView { GoalsView(
        list: list
    ) }

    func makeDataSource(list: UICollectionView) -> GoalsDataSource { GoalsDataSource(
        list: list,
        viewModel: makeGoalsViewModel(),
        createGoalService: makeCreateGoalService(),
        deleteGoalService: makeDeleteGoalService(),
        updateServiceFactory: self
    ) }

    func makeCreateGoalService() -> CreateGoalService { CreateGoalService(
        goalsStorage: parent.parent.goalsWriter,
        eventsProvider: parent.parent.eventsReader
    ) }

    func makeDeleteGoalService() -> DeleteGoalService { DeleteGoalService(goalsStorage: parent.parent.goalsWriter) }

    // MARK: - ViewModels

    func makeGoalsViewModel() -> GoalsViewModel { GoalsViewModel(
        cells: [
            .goals: parent.parent.goalsReader.read(forEvent: parent.event).map { makeGoalViewModel(goal: $0) },
            .createGoal: [makeCreateGoalViewModel()],
        ]
    ) }

    func makeGoalViewModel(goal: Goal) -> GoalViewModel { GoalViewModel(goal: goal) }
    func makeCreateGoalViewModel() -> CreateGoalViewModel { CreateGoalViewModel(eventId: parent.eventId) }

    // MARK: - Services
    func makeUpdateGoalService(goalId: String) -> UpdateGoalService { UpdateGoalService(
        goalId: goalId,
        goalsReader: parent.parent.goalsReader,
        goalsWriter: parent.parent.goalsWriter
    ) }
}
