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

struct EventsListUseCasingStub: EventsListUseCasing {
    let events: [Event]

    init(events: [Event] = []) { self.events = events }

    func makeAllEvents() -> [Domain.Event] { events }

    func add(name: String) {}

    func remove(_: Domain.Event) {}

    func add(delegate: IosUseCases.EventsListUseCasingDelegate) {}

    func remove(delegate: IosUseCases.EventsListUseCasingDelegate) {}
}

struct EventEditUseCasingStub: EventEditUseCasing {
    func visit(_: Domain.Event) {}

    func addHappening(to: Domain.Event, date: Date) {}

    func removeHappening(from: Domain.Event, happening: Domain.Happening) {}

    func addGoal(to: Domain.Event, at: Date, amount: Int) {}

    func rename(_: Domain.Event, to: String) {}

    func add(delegate: IosUseCases.EventEditUseCasingDelegate) {}

    func remove(delegate: IosUseCases.EventEditUseCasingDelegate) {}
}
