//
//  RemoveEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct RemoveEventService: ApplicationService {
    private let eventsStorage: EventsWriting
    private let eventsProvider: EventsReading
    private let eventId: String

    init(eventId: String, eventsStorage: EventsWriting, eventsProvider: EventsReading) {
        self.eventId = eventId
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: ApplicationServiceEmptyArgument) {
        eventsStorage.delete(id: eventId)

        DomainEventsPublisher.shared.publish(EventRemoved(eventId: eventId))
    }
}
