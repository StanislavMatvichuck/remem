//
//  VisitEventService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Domain
import Foundation

struct VisitEventService: ApplicationService {
    private let event: Event
    private let repository: EventsCommanding

    init(event: Event, repository: EventsCommanding) {
        self.event = event
        self.repository = repository
    }

    func serve(_: ApplicationServiceEmptyArgument) {
        event.visit()

        repository.save(event)

        DomainEventsPublisher.shared.publish(EventVisited(event: event))
    }
}
