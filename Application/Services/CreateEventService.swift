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
    let dateCreated: Date
}

struct CreateEventService: ApplicationService {
    private let repository: EventsCommanding
    
    init(repository: EventsCommanding) {
        self.repository = repository
    }
    
    func serve(_ argument: CreateEventServiceArgument) {
        let newEvent = Event(name: argument.name, dateCreated: argument.dateCreated)
        repository.save(newEvent)
        DomainEventsPublisher.shared.publish(EventCreated(event: newEvent))
    }
}
