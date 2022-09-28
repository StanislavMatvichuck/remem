//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Domain
import Foundation

public protocol EventsListUseCasing {
    func allEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)

    func add(delegate: EventsListUseCasingDelegate)
    func remove(delegate: EventsListUseCasingDelegate)
}

public class EventsListUseCase: EventsListUseCasing {
    // MARK: - Properties
    private var repository: EventsRepositoryInterface
    private var delegates: MulticastDelegate<EventsListUseCasingDelegate>
    private let widgetUseCase: WidgetsUseCasing
    // MARK: - Init
    public init(repository: EventsRepositoryInterface,
                widgetUseCase: WidgetsUseCasing)
    {
        self.repository = repository
        self.widgetUseCase = widgetUseCase
        self.delegates = MulticastDelegate<EventsListUseCasingDelegate>()
    }

    // EventsListUseCasing
    public func allEvents() -> [Event] { repository.all() }
    public func add(name: String) {
        let newEvent = Event(name: name)

        repository.save(newEvent)

        guard let addedEvent = repository.event(byId: newEvent.id) else { return }
        delegates.call { $0.added(event: addedEvent) }
        widgetUseCase.update()
    }

    public func remove(_ event: Event) {
        repository.delete(event)
        delegates.call { $0.removed(event: event) }
        widgetUseCase.update()
    }

    public func add(delegate: EventsListUseCasingDelegate) { delegates.addDelegate(delegate) }
    public func remove(delegate: EventsListUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

public protocol EventsListUseCasingDelegate: AnyObject {
    func added(event: Event)
    func removed(event: Event)
}
