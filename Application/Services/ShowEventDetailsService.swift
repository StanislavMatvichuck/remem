//
//  ShowEventDetailsService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.03.2024.
//

import Domain
import Foundation

protocol ShowEventDetailsServiceFactoring {
    func makeShowEventDetailsService() -> ShowEventDetailsService
}

protocol EventDetailsControllerFactoring {
    func makeEventDetailsController(event: Event) -> EventDetailsViewController
}

struct ShowEventDetailsServiceArgument {
    let eventId: String
}

struct ShowEventDetailsService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: EventDetailsControllerFactoring
    private let eventsProvider: EventsQuerying

    init(
        coordinator: Coordinator,
        factory: EventDetailsControllerFactoring,
        eventsProvider: EventsQuerying
    ) {
        self.coordinator = coordinator
        self.factory = factory
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: ShowEventDetailsServiceArgument) {
        let event = eventsProvider.get().first(where: { $0.id == arg.eventId })!

        coordinator.goto(
            navigation: .eventDetails,
            controller: factory.makeEventDetailsController(event: event)
        )
    }
}
