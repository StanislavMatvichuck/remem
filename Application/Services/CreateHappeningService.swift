//
//  CreateHappeningService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.03.2024.
//

import Domain
import Foundation

struct CreateHappeningServiceArgument { let date: Date }
struct CreateHappeningService: ApplicationService {
    private let eventsStorage: EventsWriting
    private let eventsProvider: EventsReading
    private let eventId: String

    init(
        eventId: String,
        eventsStorage: EventsWriting,
        eventsProvider: EventsReading
    ) {
        self.eventId = eventId
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: CreateHappeningServiceArgument) {
        var event = eventsProvider.read(byId: eventId)
        event.addHappening(date: arg.date)

        eventsStorage.update(id: eventId, event: event)

        DomainEventsPublisher.shared.publish(HappeningCreated(eventId: eventId))
    }
}
