//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Foundation
import Domain
import IosUseCases

public protocol EventsListViewModeling:
    EventsListViewModelState &
    EventsListViewModelEvents {}

public protocol EventsListViewModelState {
    var isAddButtonHighlighted: Bool { get }
    var hint: HintState { get }
    var eventsAmount: Int { get }
    func event(at: Int) -> Event?
}

public protocol EventsListViewModelEvents: AnyObject {
    func select(event: Event)
    func selectForRenaming(event: Event)
    func selectForRemoving(event: Event)
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

public class EventsListViewModel: EventsListViewModeling {
    // MARK: - Properties
    public weak var delegate: EventsListViewModelDelegate?
    public weak var coordinator: Coordinating?

    private let listUseCase: EventsListUseCasing
    private let editUseCase: EventEditUseCasing

    private var renamedEvent: Event?
    private var events: [Event]
    // MARK: - Init
    public init(listUseCase: EventsListUseCasing,
         editUseCase: EventEditUseCasing)
    {
        self.events = listUseCase.allEvents()
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
    }

    // EventsListViewModelState
    public var eventsAmount: Int { events.count }
    public var isAddButtonHighlighted: Bool { events.count == 0 }
    public var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .swipeLeft
    }

    public func event(at index: Int) -> Event? {
        guard index < events.count, index >= 0 else { return nil }
        return events[index]
    }

    // EventsListViewModelEvents
    public func select(event: Event) { coordinator?.showDetails(event: event) }
    public func cancelNameEditing() { renamedEvent = nil }
    public func selectForRemoving(event: Event) { listUseCase.remove(event) }
    public func selectForRenaming(event: Event) {
        renamedEvent = event
        delegate?.askNewName(withOldName: event.name)
    }

    public func submitNameEditing(name: String) {
        if let renamedEvent = renamedEvent {
            editUseCase.rename(renamedEvent, to: name)
        } else {
            listUseCase.add(name: name)
        }
    }
}

// MARK: - EventsListUseCaseDelegate & EventEditUseCaseDelegate
extension EventsListViewModel: EventsListUseCaseDelegate, EventEditUseCaseDelegate {
    // EventsListUseCaseDelegate
    public func added(event: Event) {
        events = listUseCase.allEvents()

        if let index = events.firstIndex(of: event) {
            delegate?.addEvent(at: index)
        }

        delegate?.update()
    }

    public func removed(event: Event) {
        if let index = events.firstIndex(of: event) {
            events = listUseCase.allEvents()
            delegate?.remove(at: index)
        }

        delegate?.update()
    }

    // EventEditUseCaseDelegate
    public func added(happening: Happening, to: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    public func visited(event: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    public func removed(happening: Happening, from: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    public func renamed(event: Event) {}
    public func added(goal: Goal, to: Event) {}
}

// MARK: - EventsListViewModelDelegate
public protocol EventsListViewModelDelegate: AnyObject {
    func update()
    func addEvent(at: Int)
    func remove(at: Int)
    func update(at: Int)
    func askNewName(withOldName: String)
}

public enum HintState: String {
    case empty
    case placeFirstMark
    case pressMe
    case swipeLeft

    public var text: String? {
        switch self {
        case .empty:
            return NSLocalizedString("empty.EventsList", comment: "entries list empty")
        case .placeFirstMark:
            return NSLocalizedString("empty.EventsList.firstHappening", comment: "entries list first point")
        case .pressMe:
            return NSLocalizedString("empty.EventsList.firstDetailsInspection", comment: "entries list first details opening")
        case .swipeLeft:
            return "swipe left to modify"
        }
    }
}
