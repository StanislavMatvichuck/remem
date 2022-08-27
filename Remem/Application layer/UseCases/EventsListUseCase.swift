//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventsListUseCaseOutput: AnyObject {
    func added(event: Event)
    func removed(event: Event)
}

class EventsListUseCase {
    // MARK: - Properties
    weak var delegate: EventsListUseCaseOutput?

    private var repository: EventsRepositoryInterface

    // MARK: - Init
    init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }
}

protocol EventsListUseCaseInput {
    func allEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)
}

// MARK: - Public
extension EventsListUseCase: EventsListUseCaseInput {
    func allEvents() -> [Event] { repository.all() }

    func add(name: String) {
        let newEvent = Event(name: name)
        repository.save(newEvent)

        guard let addedEvent = repository.event(byId: newEvent.id) else { return }
        delegate?.added(event: addedEvent)
    }

    func remove(_ event: Event) {
        repository.delete(event)
        delegate?.removed(event: event)
    }
}
