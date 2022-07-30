//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventsListUseCaseInput {
    func list() -> [Event]
    func event(at: Int) -> Event?
    func add(name: String)
    func remove(_: Event)
}

protocol EventsListUseCaseOutput: AnyObject {
    func eventsListUpdated(_: [Event])
}

class EventsListUseCase {
    // MARK: - Properties
    weak var delegate: EventsListUseCaseOutput?

    private var repository: EventsRepositoryInput

    // MARK: - Init
    init(repository: EventsRepositoryInput) {
        self.repository = repository
    }
}

// MARK: - Public
extension EventsListUseCase: EventsListUseCaseInput {
    func list() -> [Event] { repository.allEvents() }

    func event(at index: Int) -> Event? { repository.event(at: index) }

    func add(name: String) {
        repository.add(name: name)
        delegate?.eventsListUpdated(repository.allEvents())
    }

    func remove(_ event: Event) {
        repository.remove(event)
        delegate?.eventsListUpdated(repository.allEvents())
    }
}
