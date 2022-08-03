//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventEditUseCaseInput {
    func visit(_: Event)
    func addHappening(to: Event, date: Date)
//    func rename(_: DomainEvent, to: String)
}

protocol EventEditUseCaseOutput: AnyObject {
    func updated(_: Event)
}

class EventEditUseCase {
    typealias Repository = EventsRepositoryInterface

    weak var delegate: EventEditUseCaseOutput?
    // MARK: - Properties
    private let repository: Repository
    // MARK: - Init
    init(repository: Repository) { self.repository = repository }
}

// MARK: - Private
extension EventEditUseCase: EventEditUseCaseInput {
    func visit(_ event: Event) {
        var editedEvent = event
        editedEvent.dateVisited = .now
        repository.save(editedEvent)
        delegate?.updated(editedEvent)
    }

    func addHappening(to event: Event, date: Date) {
        var editedEvent = event
        editedEvent.happenings.append(Happening(dateCreated: date))
        repository.save(editedEvent)
        delegate?.updated(editedEvent)
    }

//    func rename(_ event: DomainEvent, to newName: String) {
//        event.name = newName
//        delegate?.updated(event)
//    }
}
