//
//  DeleteGoalService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import Domain
import Foundation

struct DeleteGoalServiceArgument { let goalId: String }
struct DeleteGoalService: ApplicationService {
    private let goalsStorage: GoalsWriting

    init(goalsStorage: GoalsWriting) { self.goalsStorage = goalsStorage }

    func serve(_ arg: DeleteGoalServiceArgument) {
        goalsStorage.delete(id: arg.goalId)

        DomainEventsPublisher.shared.publish(GoalDeleted())
    }
}
