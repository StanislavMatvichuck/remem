//
//  VisitEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct VisitEventServiceArgument {
    let date: Date
}

struct VisitEventService: ApplicationService {
    private let event: Event
    private let repository: EventsWriting

    init(event: Event, repository: EventsWriting) {
        self.event = event
        self.repository = repository
    }

    func serve(_ arg: VisitEventServiceArgument) {
//        var visitedEvent = event
//
//        visitedEvent.visit(at: arg.date)
//
//        repository.update(id: event.id, event: visitedEvent)
//
//        DomainEventsPublisher.shared.publish(EventVisited(event: event))
    }
}
