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
    private let eventsStorage: EventsCommanding
    private let eventsProvider: EventsQuerying
    private let eventId: String

    init(
        eventId: String,
        eventsStorage: EventsCommanding,
        eventsProvider: EventsQuerying
    ) {
        self.eventId = eventId
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: CreateHappeningServiceArgument) {
        let event = eventsProvider.get().first { $0.id == eventId }!

        event.addHappening(date: arg.date)

        eventsStorage.save(event)

        DomainEventsPublisher.shared.publish(HappeningCreated(eventId: eventId))
    }
}
