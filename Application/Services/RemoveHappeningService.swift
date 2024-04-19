//
//  RemoveHappeningService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 12.04.2024.
//

import Domain
import Foundation

struct RemoveHappeningServiceArgument { let happening: Happening }
struct RemoveHappeningService: ApplicationService {
    private let eventsStorage: EventsWriting
    private let eventsProvider: EventsReading
    private let eventId: String

    init(eventId: String, eventsStorage: EventsWriting, eventsProvider: EventsReading) {
        self.eventId = eventId
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: RemoveHappeningServiceArgument) {
        do {
            let event = eventsProvider.read(byId: eventId)
            try event.remove(happening: arg.happening)
            eventsStorage.update(id: eventId, event: event)

            DomainEventsPublisher.shared.publish(HappeningRemoved(eventId: eventId))
        } catch {
            fatalError("remove happening")
        }
    }
}
