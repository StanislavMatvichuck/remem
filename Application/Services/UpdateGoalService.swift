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
    private let goalsReader: GoalsReading
    private let goalsWriter: GoalsWriting
    private let goalId: String

    init(goalId: String,
         goalsReader: GoalsReading,
         goalsWriter: GoalsWriting)
    {
        self.goalsReader = goalsReader
        self.goalsWriter = goalsWriter
        self.goalId = goalId
    }

    func serve(_ arg: UpdateGoalServiceArgument) {
        if let goal = goalsReader.read(byId: goalId) {
            switch arg.input {
            case .minus: goal.update(value: Int(goal.value.amount) - 1)
            case .plus: goal.update(value: Int(goal.value.amount) + 1)
            case .text: fatalError("handle text input")
            }

            goalsWriter.update(id: goalId, goal: goal)

            DomainEventsPublisher.shared.publish(GoalValueUpdated())
        }
    }
}
