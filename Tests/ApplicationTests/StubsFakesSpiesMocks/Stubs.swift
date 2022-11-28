//
//  Stubs.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 11.11.2022.
//

@testable import Application
import Domain
import Foundation
import IosUseCases

class WidgetUseCaseStub: WidgetsUseCasing {
    func update() {}
}

class EventsListUseCasingFake: EventsListUseCasing {
    var events: [Event]

    init(events: [Event] = []) { self.events = events }

    func makeAllEvents() -> [Domain.Event] { events }

    func add(name: String) {
        events.append(Event(name: name))
        delegates.call { $0.update(events: events) }
    }

    func remove(_ event: Domain.Event) {
        if let index = events.firstIndex(of: event) {
            events.remove(at: index)
            delegates.call { $0.update(events: events) }
        }
    }

    var delegates = MulticastDelegate<EventsListUseCasingDelegate>()
    func add(delegate: EventsListUseCasingDelegate) { delegates.addDelegate(delegate) }
    func remove(delegate: EventsListUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

struct EventEditUseCasingFake: EventEditUseCasing {
    func visit(_ event: Domain.Event) {
        event.visit()
        delegates.call { $0.update(event: event) }
    }

    func addHappening(to: Domain.Event, date: Date) {
        to.addHappening(date: date)
        delegates.call { $0.update(event: to) }
    }

    func removeHappening(from: Domain.Event, happening: Domain.Happening) {}

    func rename(_ event: Domain.Event, to: String) {
        event.name = to
        delegates.call { $0.update(event: event) }
    }

    var delegates = MulticastDelegate<EventEditUseCasingDelegate>()
    func add(delegate: EventEditUseCasingDelegate) { delegates.addDelegate(delegate) }
    func remove(delegate: EventEditUseCasingDelegate) { delegates.removeDelegate(delegate) }
}
