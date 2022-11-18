//
//  Fakes.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import Domain

class EventsRepositoryFake: EventsRepositoryInterface {
    private var events: [Event]

    init(events: [Event]) {
        self.events = events
    }

    func makeAllEvents() -> [Domain.Event] { events }

    func save(_ event: Domain.Event) {
        events.append(event)
    }

    func delete(_ event: Domain.Event) {
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
        }
    }
}
