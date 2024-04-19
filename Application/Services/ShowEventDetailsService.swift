//
//  ShowEventDetailsService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.03.2024.
//

import Domain
import Foundation

protocol EventDetailsControllerFactoring {
    func makeEventDetailsController() -> EventDetailsController
}

protocol EventDetailsControllerFactoringFactoring {
    func makeEventDetailsControllerFactoring(eventId: String) -> EventDetailsControllerFactoring
}

struct ShowEventDetailsService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: EventDetailsControllerFactoringFactoring
    private let eventsProvider: EventsReading
    private let eventId: String

    init(
        eventId: String,
        coordinator: Coordinator,
        factory: EventDetailsControllerFactoringFactoring,
        eventsProvider: EventsReading
    ) {
        self.eventId = eventId
        self.coordinator = coordinator
        self.factory = factory
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: ApplicationServiceEmptyArgument) {
        let controllerFactory = factory.makeEventDetailsControllerFactoring(eventId: eventId)
        let controller = controllerFactory.makeEventDetailsController()

        coordinator.goto(navigation: .eventDetails, controller: controller)
    }
}
