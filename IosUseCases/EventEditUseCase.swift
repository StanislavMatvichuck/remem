//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation
import Domain

public protocol EventEditUseCasing {
    func visit(_: Event)
    func addHappening(to: Event, date: Date)
    func removeHappening(from: Event, happening: Happening)
    func addGoal(to: Event, at: Date, amount: Int)
    func rename(_: Event, to: String)
}

public class EventEditUseCase: EventEditUseCasing {
    // MARK: - Properties
    public weak var delegate: EventEditUseCaseDelegate?
    private let repository: EventsRepositoryInterface
    // MARK: - Init
    public init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }

    // EventEditUseCasing
    public func visit(_ event: Event) {
        event.dateVisited = .now
        repository.save(event)
        delegate?.visited(event: event)
    }

    public func addHappening(to event: Event, date: Date) {
        let addedHappening = event.addHappening(date: date)
        repository.save(event)
        delegate?.added(happening: addedHappening, to: event)
    }

    public func removeHappening(from event: Event, happening: Happening) {
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

    public func rename(_ event: Event, to newName: String) {
        event.name = newName
        repository.save(event)
        delegate?.renamed(event: event)
    }

    public func addGoal(to event: Event, at date: Date, amount: Int) {
        let addedGoal = event.addGoal(at: date, amount: amount)
        repository.save(event)
        delegate?.added(goal: addedGoal, to: event)
    }
}

public protocol EventEditUseCaseDelegate: AnyObject {
    func added(happening: Happening, to: Event)
    func removed(happening: Happening, from: Event)
    func renamed(event: Event)
    func visited(event: Event)
    func added(goal: Goal, to: Event)
}
