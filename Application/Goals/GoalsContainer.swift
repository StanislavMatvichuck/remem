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
    GoalsViewModelFactoring,
    GoalViewModelFactoring
{
    private let parent: EventDetailsContainer
    private let goalsStorage: GoalsWriting & GoalsReading
    private let list = GoalsView.makeList()
    private var eventId: String { parent.event.id }

    init(_ parent: EventDetailsContainer) {
        self.parent = parent
        self.goalsStorage = GoalsCoreDataRepository(container: parent.parent.coreDataContainer)
    }

    func makeGoalsController() -> GoalsController { GoalsController(factory: self, view: makeGoalsView()) }
    func makeGoalsView() -> GoalsView { GoalsView(
        list: list,
        dataSource: makeDataSource(list: list)
    ) }

    func makeDataSource(list: UICollectionView) -> GoalsDataSource { GoalsDataSource(
        list: list,
        provider: self,
        createGoalService: makeCreateGoalService()
    ) }
    func makeCreateGoalService() -> CreateGoalService { CreateGoalService(
        goalsStorage: goalsStorage,
        eventsProvider: parent.parent.provider
    ) }

    // MARK: - ViewModels

    func makeGoalsViewModel() -> GoalsViewModel {
        GoalsViewModel(cells: [
            .goals: goalsStorage.read(forEvent: parent.event).map { makeGoalViewModel(goal: $0) },
            .createGoal: [makeCreateGoalViewModel()]
        ])
    }

    func makeGoalViewModel(goal: Goal) -> GoalViewModel { GoalViewModel(goal: goal) }
    func makeCreateGoalViewModel() -> CreateGoalViewModel { CreateGoalViewModel(eventId: eventId) }
}
