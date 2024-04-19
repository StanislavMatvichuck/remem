//
//  CreateEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct CreateEventServiceArgument {
    let name: String
}

struct CreateEventService: ApplicationService {
    private let eventsStorage: EventsWriting

    init(eventsStorage: EventsWriting) { self.eventsStorage = eventsStorage }

    func serve(_ arg: CreateEventServiceArgument) {
        let createdEvent = Event(name: arg.name, dateCreated: .now)

        eventsStorage.create(event: createdEvent)

        DomainEventsPublisher.shared.publish(EventCreated(event: createdEvent))
    }
}
