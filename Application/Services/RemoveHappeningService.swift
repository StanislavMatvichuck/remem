//
//  RemoveHappeningService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 12.04.2024.
//

import Domain
import Foundation

struct RemoveHappeningServiceArgument {
    let eventId: String
    let happening: Happening
}

struct RemoveHappeningService: ApplicationService {
    private let eventsStorage: EventsCommanding
    private let eventsProvider: EventsQuerying

    init(eventsStorage: EventsCommanding, eventsProvider: EventsQuerying) {
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: RemoveHappeningServiceArgument) {
        let event = eventsProvider.get().first { $0.id == arg.eventId }!

        do {
            try event.remove(happening: arg.happening)
        } catch {
            fatalError("remove happening")
        }

        eventsStorage.save(event)

        DomainEventsPublisher.shared.publish(HappeningRemoved(eventId: arg.eventId))
    }
}
