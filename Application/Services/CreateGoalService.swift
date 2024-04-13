//
//  CreateGoalService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 12.04.2024.
//

import Domain
import Foundation

struct CreateGoalServiceArgument {
    let eventId: String
    let dateCreated: Date
}

struct CreateGoalService: ApplicationService {
    private let goalsStorage: GoalsWriting
    private let eventsProvider: EventsQuerying

    init(goalsStorage: GoalsWriting, eventsProvider: EventsQuerying) {
        self.goalsStorage = goalsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: CreateGoalServiceArgument) {
        let event = eventsProvider.get().first { $0.id == arg.eventId }!

        let goal = Goal(dateCreated: arg.dateCreated, event: event)

        goalsStorage.create(goal: goal)

        DomainEventsPublisher.shared.publish(GoalCreated(eventId: arg.eventId, goal: goal))
    }
}
