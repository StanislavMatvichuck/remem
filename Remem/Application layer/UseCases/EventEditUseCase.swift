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
    func removeHappening(from: Event, happening: Happening)
    func rename(_: Event, to: String)
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
        do {
            var editedEvent = event
            try editedEvent.addHappening(date: date)

            repository.save(editedEvent)
            delegate?.updated(editedEvent)
        } catch {
            switch error {
            case EventManipulationError.incorrectHappeningDate:
                fatalError("Date of happening must be greater than date of creation")
            default:
                fatalError("Error adding happening to event")
            }
        }
    }

    func removeHappening(from event: Event, happening: Happening) {
        do {
            var updatedEvent = event
            try updatedEvent.remove(happening: happening)

            repository.save(updatedEvent)
            delegate?.updated(updatedEvent)
        } catch {
            switch error {
            case EventManipulationError.invalidHappeningDeletion:
                fatalError("Unable to find happening to delete")
            default:
                fatalError("Error deleting happening \(error)")
            }
        }
    }

    func rename(_ event: Event, to newName: String) {
        var updatedEvent = event

        updatedEvent.name = newName

        repository.save(updatedEvent)
        delegate?.updated(event)
    }
}
