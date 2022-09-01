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
    func rename(_: Event, to: String)
}

class EventEditUseCase: EventEditUseCaseInput {
    // MARK: - Properties
    weak var delegate: EventEditUseCaseOutput?
    private let repository: EventsRepositoryInterface
    // MARK: - Init
    init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }

    // EventEditUseCaseInput
    func visit(_ event: Event) {
        event.dateVisited = .now
        repository.save(event)
        delegate?.visited(event: event)
    }

    func addHappening(to event: Event, date: Date) {
        let addedHappening = event.addHappening(date: date)
        repository.save(event)
        delegate?.added(happening: addedHappening, to: event)
    }

    func removeHappening(from event: Event, happening: Happening) {
        do {
            if let removedHappening = try event.remove(happening: happening) {
                repository.save(event)
                delegate?.removed(happening: removedHappening, from: event)
            }
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
        delegate?.renamed(event: event)
    }

    func addGoal(to event: Event, at date: Date, amount: Int) {
        let addedGoal = event.addGoal(at: date, amount: amount)
        delegate?.added(goal: addedGoal, to: event)
    }
}

protocol EventEditUseCaseOutput: AnyObject {
    func added(happening: Happening, to: Event)
    func removed(happening: Happening, from: Event)
    func renamed(event: Event)
    func visited(event: Event)
    func added(goal: Goal, to: Event)
}
