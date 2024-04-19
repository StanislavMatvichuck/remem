//
//  UpdateGoalService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import Domain
import Foundation

struct UpdateGoalServiceArgument {
    enum Input { case minus, plus, text }
    let input: Input
}

struct UpdateGoalService: ApplicationService {
    private let goalsStorage: GoalsWriting & GoalsReading
    private let goalId: String

    init(goalId: String, goalsStorage: GoalsWriting & GoalsReading) {
        self.goalsStorage = goalsStorage
        self.goalId = goalId
    }

    func serve(_ arg: UpdateGoalServiceArgument) {
        if let goal = goalsStorage.read(byId: goalId) {
            switch arg.input {
            case .minus: goal.update(value: Int(goal.value.amount) - 1)
            case .plus: goal.update(value: Int(goal.value.amount) + 1)
            case .text: fatalError("handle text input")
            }

            goalsStorage.update(id: goalId, goal: goal)

            DomainEventsPublisher.shared.publish(GoalValueUpdated())
        }
    }
}
