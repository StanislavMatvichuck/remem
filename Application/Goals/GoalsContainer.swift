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
    private let list = GoalsView.makeList()
    private var eventId: String { parent.event.id }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func makeGoalsController() -> GoalsViewController { GoalsViewController(factory: self, view: makeGoalsView()) }
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
        goalsStorage: repository,
        eventsProvider: parent.parent.provider
    ) }

    // MARK: - ViewModels

    func makeGoalsViewModel() -> GoalsViewModel {
        GoalsViewModel(cells: [
            .goals: repository.read(forEvent: parent.event).map { makeGoalViewModel(goal: $0) },
            .createGoal: [makeCreateGoalViewModel()]
        ])
    }

    func makeGoalViewModel(goal: Goal) -> GoalViewModel { GoalViewModel(goal: goal) }
    func makeCreateGoalViewModel() -> CreateGoalViewModel { CreateGoalViewModel(eventId: eventId) }
}

final class TemporaryGoalsRepository: GoalsReading, GoalsWriting {
    private var goals: [Goal] = []

    func read(forEvent: Event) -> [Domain.Goal] { goals }

    func create(goal: Domain.Goal) { goals.append(goal) }

    func update(id: String, goal: Domain.Goal) {
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals[index] = goal
        }
    }

    func delete(id: String) {
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals.remove(at: index)
        }
    }
}
