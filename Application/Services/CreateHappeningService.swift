//
//  CreateHappeningService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.03.2024.
//

import Domain
import Foundation

struct CreateHappeningServiceArgument { let eventId: String; let date: Date }
struct CreateHappeningService: ApplicationService {
    private let eventsStorage: EventsWriting
    private let eventsProvider: EventsReading

    init(
        eventsStorage: EventsWriting,
        eventsProvider: EventsReading
    ) {
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: CreateHappeningServiceArgument) {
        var event = eventsProvider.read(byId: arg.eventId)
        event.addHappening(date: arg.date)

        eventsStorage.update(id: arg.eventId, event: event)

        DomainEventsPublisher.shared.publish(HappeningCreated(eventId: arg.eventId))
    }
}
