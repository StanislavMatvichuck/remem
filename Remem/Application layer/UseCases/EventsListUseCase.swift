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

    private var repository: EventsRepositoryInterface

    // MARK: - Init
    init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }
}

// MARK: - Public
extension EventsListUseCase: EventsListUseCaseInput {
    func list() -> [Event] { repository.all() }

    func event(at index: Int) -> Event? { repository.all()[index] }

    func add(name: String) {
        var allEvents = repository.all()
        let newEvent = Event(id: UUID().uuidString,
                                   name: name, happenings: [],
                                   dateCreated: .now)
        allEvents.append(newEvent)
        repository.save(allEvents)
        delegate?.eventsListUpdated(repository.all())
    }

    func remove(_ event: Event) {
        repository.delete(event)
        delegate?.eventsListUpdated(repository.all())
    }
}
