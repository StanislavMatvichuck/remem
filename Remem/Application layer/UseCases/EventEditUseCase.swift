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
    func addGoal(to: Event, at: Date, amount: Int)
    func disableGoal(at: Event, at: Date)
    func rename(_: Event, to: String)
}

protocol EventEditUseCaseOutput: AnyObject {
    func updated(event: Event)
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
        event.dateVisited = .now
        repository.save(event)
        delegate?.updated(event: event)
    }

    func addHappening(to event: Event, date: Date) {
        do {
            try event.addHappening(date: date)

            repository.save(event)
            delegate?.updated(event: event)
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
            try event.remove(happening: happening)

            repository.save(event)
            delegate?.updated(event: event)
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
        event.name = newName

        repository.save(event)
        delegate?.updated(event: event)
    }

    func addGoal(to event: Event, at date: Date, amount: Int) {
        event.addGoal(at: date, amount: amount)
        delegate?.updated(event: event)
    }

    func disableGoal(at event: Event, at date: Date) {
        event.disableGoal(at: date)
        delegate?.updated(event: event)
    }
}
