//
//  Fakes.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import Domain

class EventsRepositoryFake:
    EventsQuerying,
    EventsCommanding
{
    var events: [Event]

    init(events: [Event] = []) { self.events = events }

    func get() -> [Domain.Event] { events }

    func save(_ event: Domain.Event) {
        if let existingEventIndex = events.firstIndex(of: event) {
            events[existingEventIndex] = event
        } else {
            events.append(event)
        }
    }

    func delete(_ event: Domain.Event) {
        guard let existingEventIndex = events.firstIndex(of: event) else { return }
        events.remove(at: existingEventIndex)
    }
}
