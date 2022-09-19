//
//  EventsListUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 30.07.2022.
//

import Foundation
import RememDomain

public protocol EventsListUseCasing {
    func allEvents() -> [Event]
    func add(name: String)
    func remove(_: Event)
}

public class EventsListUseCase: EventsListUseCasing {
    // MARK: - Properties
    public weak var delegate: EventsListUseCaseDelegate?
    private var repository: EventsRepositoryInterface
    private var widgetRepository: WidgetRepositoryInterface
    // MARK: - Init
    public init(repository: EventsRepositoryInterface,
                widgetRepository: WidgetRepositoryInterface)
    {
        self.repository = repository
        self.widgetRepository = widgetRepository
    }

    // EventsListUseCasing
    public func allEvents() -> [Event] { repository.all() }
    public func add(name: String) {
        let newEvent = Event(name: name)

        repository.save(newEvent)

        guard let addedEvent = repository.event(byId: newEvent.id) else { return }
        delegate?.added(event: addedEvent)
        widgetRepository.update(eventsList: repository.all())
    }

    public func remove(_ event: Event) {
        repository.delete(event)
        delegate?.removed(event: event)
        widgetRepository.update(eventsList: repository.all())
    }
}

public protocol EventsListUseCaseDelegate: AnyObject {
    func added(event: Event)
    func removed(event: Event)
}
