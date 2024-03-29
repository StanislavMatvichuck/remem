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
    private let repository: EventsCommanding

    init(event: Event, repository: EventsCommanding) {
        self.event = event
        self.repository = repository
    }

    func serve(_ arg: VisitEventServiceArgument) {
        event.visit(at: arg.date)

        repository.save(event)

        DomainEventsPublisher.shared.publish(EventVisited(event: event))
    }
}
