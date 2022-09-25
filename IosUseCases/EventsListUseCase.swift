//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Domain
import Foundation

public protocol EventsListUseCasing {
    func allEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)
}

public class EventsListUseCase: EventsListUseCasing {
    // MARK: - Properties
    public weak var delegate: EventsListUseCaseDelegate?
    private var repository: EventsRepositoryInterface
    // MARK: - Init
    public init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }

    // EventsListUseCasing
    public func allEvents() -> [Event] { repository.all() }
    public func add(name: String) {
        let newEvent = Event(name: name)

        repository.save(newEvent)

        guard let addedEvent = repository.event(byId: newEvent.id) else { return }
        delegate?.added(event: addedEvent)
    }

    public func remove(_ event: Event) {
        repository.delete(event)
        delegate?.removed(event: event)
    }
}

public protocol EventsListUseCaseDelegate: AnyObject {
    func added(event: Event)
    func removed(event: Event)
}
