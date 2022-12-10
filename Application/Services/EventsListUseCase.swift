//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Domain
import Foundation

protocol EventsListUseCasing {
    func makeAllEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)

    func add(delegate: EventsListUseCasingDelegate)
    func remove(delegate: EventsListUseCasingDelegate)
}

class EventsListUseCase: EventsListUseCasing {
    // MARK: - Properties
    private var repository: EventsRepositoryInterface
    private var delegates: MulticastDelegate<EventsListUseCasingDelegate>

    // MARK: - Init
    init(repository: EventsRepositoryInterface) {
        self.repository = repository
        self.delegates = MulticastDelegate<EventsListUseCasingDelegate>()
    }

    // EventsListUseCasing
    func makeAllEvents() -> [Event] { repository.makeAllEvents() }
    func add(name: String) {
        let createdEvent = Event(name: name)

        repository.save(createdEvent)
        delegates.call { $0.update(events: repository.makeAllEvents()) }
    }

    func remove(_ event: Event) {
        repository.delete(event)
        delegates.call { $0.update(events: repository.makeAllEvents()) }
    }

    func add(delegate: EventsListUseCasingDelegate) { delegates.addDelegate(delegate) }
    func remove(delegate: EventsListUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

protocol EventsListUseCasingDelegate: AnyObject {
    func update(events: [Event])
}
