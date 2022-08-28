//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import UIKit

enum HintState {
    case empty
    case placeFirstMark
    case pressMe
    case noHints

    var text: String? {
        switch self {
        case .empty:
            return EventsListView.empty
        case .placeFirstMark:
            return EventsListView.firstHappening
        case .pressMe:
            return EventsListView.firstDetails
        case .noHints:
            return nil
        }
    }
}

protocol EventsListViewModelInput:
    EventsListViewModelInputState &
    EventsListViewModelInputEvents {}

class EventsListViewModel: EventsListViewModelInput {
    // MARK: - Properties
    weak var view: EventsListViewModelOutput?
    weak var controller: EventsListControllerInput?

    private var renamedEvent: Event?
    private var events: [Event]
    // MARK: - Init
    init(events: [Event]) {
        self.events = events
        view?.update()
    }
}

protocol EventsListViewModelInputState {
    var isAddButtonHighlighted: Bool { get }
    var hint: HintState { get }
    var eventsAmount: Int { get }
    func event(at: IndexPath) -> Event?
}

extension EventsListViewModel: EventsListViewModelInputState {
    var eventsAmount: Int { events.count }
    var isAddButtonHighlighted: Bool { events.count == 0 }
    var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .noHints
    }

    func event(at index: IndexPath) -> Event? {
        guard index.row < events.count, index.row >= 0 else { return nil }
        return events[index.row]
    }
}

protocol EventsListViewModelInputEvents: AnyObject {
    func select(event: Event)
    func selectForRenaming(event: Event)
    func selectForRemoving(event: Event)
    func addHappening(to: Event)
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

extension EventsListViewModel: EventsListViewModelInputEvents {
    func select(event: Event) {
        controller?.select(event: event)
    }

    func addHappening(to: Event) {
        controller?.addHappening(to: to)
    }

    func selectForRemoving(event: Event) {
        controller?.remove(event: event)
    }

    func selectForRenaming(event: Event) {
        renamedEvent = event
        view?.askNewName(withOldName: event.name)
    }

    func cancelNameEditing() { renamedEvent = nil }

    func submitNameEditing(name: String) {
        if let renamedEvent = renamedEvent {
            controller?.rename(event: renamedEvent, to: name)
            self.renamedEvent = nil
        } else {
            controller?.addEvent(name: name)
        }
    }
}

protocol EventsListViewModelOutput: UIView {
    func update()
    func addEvent(at: Int)
    func remove(at: Int)
    func update(at: Int)
    func askNewName(withOldName: String)
}

// MARK: - EventsListControllerOutput
extension EventsListViewModel: EventsListControllerOutput {
    func added(event: Event, newList: [Event]) {
        events = newList

        if let index = events.firstIndex(of: event) {
            view?.addEvent(at: index)
        }

        view?.update()
    }

    func removed(event: Event, newList: [Event]) {
        if let index = events.firstIndex(of: event) {
            events = newList
            view?.remove(at: index)
        }

        view?.update()
    }

    func updated(event: Event, newList: [Event]) {
        events = newList

        if let index = events.firstIndex(of: event) {
            view?.update(at: index)
        }

        view?.update()
    }
}
