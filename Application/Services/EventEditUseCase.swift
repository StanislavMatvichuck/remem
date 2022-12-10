//
//  EventEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Domain
import Foundation

protocol EventEditUseCasing {
    func visit(_: Event)
    func addHappening(to: Event, date: Date)
    func removeHappening(from: Event, happening: Happening)
    func rename(_: Event, to: String)

    func add(delegate: EventEditUseCasingDelegate)
    func remove(delegate: EventEditUseCasingDelegate)
}

class EventEditUseCase: EventEditUseCasing {
    private let repository: EventsRepositoryInterface
    private let delegates: MulticastDelegate<EventEditUseCasingDelegate>

    init(repository: EventsRepositoryInterface) {
        self.repository = repository
        self.delegates = MulticastDelegate<EventEditUseCasingDelegate>()
    }

    // EventEditUseCasing
    func visit(_ event: Event) {
        guard event.dateVisited == nil else { return }

        event.dateVisited = .now
        repository.save(event)
        delegates.call { $0.update(event: event) }
    }

    func addHappening(to event: Event, date: Date) {
        _ = event.addHappening(date: date)
        repository.save(event)
        delegates.call { $0.update(event: event) }
    }

    func removeHappening(from event: Event, happening: Happening) {
        do {
            if let _ = try event.remove(happening: happening) {
                repository.save(event)
                delegates.call { $0.update(event: event) }
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
        delegates.call { $0.update(event: event) }
    }

    func add(delegate: EventEditUseCasingDelegate) { delegates.addDelegate(delegate) }
    func remove(delegate: EventEditUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

protocol EventEditUseCasingDelegate: AnyObject {
    func update(event: Event)
}
