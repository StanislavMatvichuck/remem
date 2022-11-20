//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Domain
import Foundation

public protocol EventEditUseCasing {
    func visit(_: Event)
    func addHappening(to: Event, date: Date)
    func removeHappening(from: Event, happening: Happening)
    func addGoal(to: Event, at: Date, amount: Int)
    func rename(_: Event, to: String)

    func add(delegate: EventEditUseCasingDelegate)
    func remove(delegate: EventEditUseCasingDelegate)
}

public class EventEditUseCase: EventEditUseCasing {
    // MARK: - Properties
    private let repository: EventsRepositoryInterface
    private let delegates: MulticastDelegate<EventEditUseCasingDelegate>
    private let widgetUseCase: WidgetsUseCasing
    // MARK: - Init
    public init(repository: EventsRepositoryInterface,
                widgetUseCase: WidgetsUseCasing)
    {
        self.repository = repository
        self.widgetUseCase = widgetUseCase
        self.delegates = MulticastDelegate<EventEditUseCasingDelegate>()
    }

    // EventEditUseCasing
    public func visit(_ event: Event) {
        event.dateVisited = .now
        repository.save(event)
        delegates.call { $0.update(event: event) }
    }

    public func addHappening(to event: Event, date: Date) {
        let addedHappening = event.addHappening(date: date)
        repository.save(event)
        delegates.call { $0.update(event: event) }
        widgetUseCase.update()
    }

    public func removeHappening(from event: Event, happening: Happening) {
        do {
            if let removedHappening = try event.remove(happening: happening) {
                repository.save(event)
                delegates.call { $0.update(event: event) }
                widgetUseCase.update()
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
        delegates.call { $0.update(event: event) }
        widgetUseCase.update()
    }

    public func addGoal(to event: Event, at date: Date, amount: Int) {
        let addedGoal = event.addGoal(at: date, amount: amount)
        repository.save(event)
        delegates.call { $0.update(event: event) }
        widgetUseCase.update()
    }

    public func add(delegate: EventEditUseCasingDelegate) { delegates.addDelegate(delegate) }
    public func remove(delegate: EventEditUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

public protocol EventEditUseCasingDelegate: AnyObject {
    func update(event: Event)
}
