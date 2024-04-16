//
//  RemoveEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct RemoveEventService: ApplicationService {
    private let eventsStorage: EventsCommanding
    private let eventsProvider: EventsQuerying
    private let eventId: String

    init(eventId: String, eventsStorage: EventsCommanding, eventsProvider: EventsQuerying) {
        self.eventId = eventId
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: ApplicationServiceEmptyArgument) {
        let event = eventsProvider.get().first { $0.id == eventId }!

        eventsStorage.delete(event)

        DomainEventsPublisher.shared.publish(EventRemoved(eventId: eventId))
    }
}
