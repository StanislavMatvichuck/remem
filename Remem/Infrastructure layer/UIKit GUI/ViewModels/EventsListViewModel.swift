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

protocol EventsListViewModelEvents: EventsListControllerInput {
    func selectedForRenaming(event: Event)
    func cancelEditing()
}

protocol EventsListViewModelOutput: UIView {
    func update()
    func addEvent(at: IndexPath)
    func remove(event: Event)
    func rename(event: Event, to: String)
    func askNewName(byOldName: String)
}

class EventsListViewModel: EventsListViewModelEvents & EventsListViewModelState {
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

    // MARK: - EventsListViewModelEvents
    func selectedForRenaming(event: Event) {
        renamedEvent = event
        view?.askNewName(byOldName: event.name)
    }

    func cancelEditing() { renamedEvent = nil }

    // EventsListControllerInput
    func handleSubmit(name: String) {
        if let renamedEvent = renamedEvent {
            controller?.rename(event: renamedEvent, to: name)
            self.renamedEvent = nil
        } else {
            controller?.handleSubmit(name: name)
        }
    }

    func addHappening(to event: Event) { controller?.addHappening(to: event) }
    func remove(event: Event) { controller?.remove(event: event) }
    func rename(event: Event, to newName: String) { controller?.rename(event: event, to: newName) }
    func select(event: Event) { controller?.select(event: event) }
}

// MARK: - EventsListControllerOutput
extension EventsListViewModel: EventsListControllerOutput {
    func update(events: [Event]) {
        self.events = events
        view?.update()
    }
}
