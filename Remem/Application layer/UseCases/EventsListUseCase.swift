//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventsListUseCaseInput {
    func allEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)
}

protocol EventsListUseCaseOutput: AnyObject {
    func eventsListUpdated(_: [Event])
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

// MARK: - Public
extension EventsListUseCase: EventsListUseCaseInput {
    func allEvents() -> [Event] { repository.all() }

    func add(name: String) {
        let newEvent = Event(name: name)

        repository.save(newEvent)
        delegate?.eventsListUpdated(repository.all())
    }

    func remove(_ event: Event) {
        repository.delete(event)
        delegate?.eventsListUpdated(repository.all())
    }
}
