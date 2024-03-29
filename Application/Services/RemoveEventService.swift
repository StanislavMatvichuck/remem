//
//  RemoveEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

protocol RemoveEventServiceFactoring { func makeRemoveEventService() -> RemoveEventService }
struct RemoveEventServiceArgument { let eventId: String }

struct RemoveEventService: ApplicationService {
    private let eventsStorage: EventsCommanding
    private let eventsProvider: EventsQuerying

    init(eventsStorage: EventsCommanding, eventsProvider: EventsQuerying) {
        self.eventsStorage = eventsStorage
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: RemoveEventServiceArgument) {
        print(#function)
        let event = eventsProvider.get().first { $0.id == arg.eventId }!

        eventsStorage.delete(event)

        DomainEventsPublisher.shared.publish(EventRemoved(eventId: event.id))
    }
}
