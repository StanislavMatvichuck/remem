//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation

protocol EventEditUseCaseInput {
    func visit(_: Event)
    func addHappening(to: Event, _: Date)
    func rename(_: Event, to: String)
}

protocol EventEditUseCaseOutput: AnyObject {
    func updated(_: Event)
}

class EventEditUseCase {
    typealias Repository = EventsRepository

    weak var delegate: EventEditUseCaseOutput?
    // MARK: - Properties
    private let repository: Repository
    // MARK: - Init
    init(repository: Repository) { self.repository = repository }
}

// MARK: - Private
extension EventEditUseCase: EventEditUseCaseInput {
    func visit(_ event: Event) {
        event.dateVisited = .now
        delegate?.updated(event)
    }

    func addHappening(to event: Event, _ date: Date) {
        repository.addHappening(to: event, date: date)
        delegate?.updated(event)
    }

    func rename(_ event: Event, to newName: String) {
        event.name = newName
        delegate?.updated(event)
    }
}
