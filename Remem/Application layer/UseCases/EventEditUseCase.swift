//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventEditUseCaseInput {
    func visit(_: DomainEvent)
    func addHappening(to: DomainEvent, date: Date)
//    func rename(_: DomainEvent, to: String)
}

protocol EventEditUseCaseOutput: AnyObject {
    func updated(_: DomainEvent)
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
    func visit(_ event: DomainEvent) {
        var editedEvent = event
        editedEvent.dateVisited = .now
        repository.save(editedEvent)
        delegate?.updated(editedEvent)
    }

    func addHappening(to event: DomainEvent, date: Date) {
        var editedEvent = event
        editedEvent.happenings.append(DomainHappening(dateCreated: date))
        repository.save(editedEvent)
        delegate?.updated(editedEvent)
    }

//    func rename(_ event: DomainEvent, to newName: String) {
//        event.name = newName
//        delegate?.updated(event)
//    }
}
