//
//  CreateEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

protocol CreateEventServiceFactoring { func makeCreateEventService() -> CreateEventService }

struct CreateEventServiceArgument {
    let name: String
}

struct CreateEventService: ApplicationService {
    private let eventsStorage: EventsCommanding

    init(eventsStorage: EventsCommanding) { self.eventsStorage = eventsStorage }

    func serve(_ arg: CreateEventServiceArgument) {
        let createdEvent = Event(name: arg.name, dateCreated: .now)

        eventsStorage.save(createdEvent)

        DomainEventsPublisher.shared.publish(EventCreated(event: createdEvent))
    }
}
