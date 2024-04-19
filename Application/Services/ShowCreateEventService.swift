//
//  ShowCreateEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.03.2024.
//

import Domain
import Foundation

protocol CreateEventControllerFactoring {
    func makeCreateEventController() -> EventCreationController
}

struct ShowCreateEventService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: CreateEventControllerFactoring
    private let eventsProvider: EventsReading

    init(
        coordinator: Coordinator,
        factory: CreateEventControllerFactoring,
        eventsProvider: EventsReading
    ) {
        self.coordinator = coordinator
        self.factory = factory
        self.eventsProvider = eventsProvider
    }

    func serve(_: ApplicationServiceEmptyArgument) {
        coordinator.goto(
            navigation: .createEvent,
            controller: factory.makeCreateEventController()
        )
    }
}
