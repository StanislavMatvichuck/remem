//
//  RemoveEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct RemoveEventServiceArgument { let eventId: String }
struct RemoveEventService: ApplicationService {
    private let eventsStorage: EventsWriting
    private let eventsProvider: EventsReading

    init(eventsStorage: EventsWriting, eventsProvider: EventsReading) {
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: RemoveEventServiceArgument) {
        eventsStorage.delete(id: arg.eventId)

        DomainEventsPublisher.shared.publish(EventRemoved(eventId: arg.eventId))
    }
}
