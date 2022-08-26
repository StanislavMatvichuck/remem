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
}

protocol EventsListViewModelState {
    var isAddButtonHighlighted: Bool { get }
    var hint: HintState { get }
    var eventsAmount: Int { get }
    func event(at: IndexPath) -> Event?
}

protocol EventsListViewModelEvents {
    func select(event: Event)
    func selectForRenaming(event: Event)
    func selectForRemoving(event: Event)
    func addHappening(to: Event)
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

protocol EventsListViewModelOutput: UIView {
    func update()
    func addEvent(at: Int)
    func remove(at: Int)
    func update(at: Int)
    func askNewName(withOldName: String)
}

class EventsListViewModel: EventsListViewModelState {
    // MARK: - Properties
    weak var view: EventsListViewModelOutput?
    weak var controller: EventsListControllerInput?

    // EventsListViewModelState
    var eventsAmount: Int { events.count }
    var isAddButtonHighlighted: Bool { events.count == 0 }
    var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .noHints
    }

    var renamedEvent: Event?

    private var events: [Event]

    // MARK: - Init
    init(events: [Event]) {
        self.events = events
        view?.update()
    }

    func event(at index: IndexPath) -> Event? {
        guard index.row < events.count, index.row >= 0 else { return nil }
        return events[index.row]
    }
}

// MARK: - EventsListViewModelEvents
extension EventsListViewModel: EventsListViewModelEvents {
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
