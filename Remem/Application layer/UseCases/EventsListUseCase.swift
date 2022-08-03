//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventsListUseCaseInput {
    func list() -> [DomainEvent]
    func event(at: Int) -> DomainEvent?
    func add(name: String)
    func remove(_: DomainEvent)
}

protocol EventsListUseCaseOutput: AnyObject {
    func eventsListUpdated(_: [DomainEvent])
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
    func list() -> [DomainEvent] { repository.all() }

    func event(at index: Int) -> DomainEvent? { repository.all()[index] }

    func add(name: String) {
        var allEvents = repository.all()
        let newEvent = DomainEvent(id: UUID().uuidString,
                                   name: name, happenings: [],
                                   dateCreated: .now)
        allEvents.append(newEvent)
        repository.save(allEvents)
        delegate?.eventsListUpdated(repository.all())
    }

    func remove(_ event: DomainEvent) {
        repository.delete(event)
        delegate?.eventsListUpdated(repository.all())
    }
}
