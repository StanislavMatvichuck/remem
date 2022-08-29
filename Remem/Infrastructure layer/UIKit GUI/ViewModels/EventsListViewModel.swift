//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import UIKit

enum HintState: String {
    case empty
    case placeFirstMark
    case pressMe
    case swipeLeft

    var text: String? {
        switch self {
        case .empty:
            return EventsListView.empty
        case .placeFirstMark:
            return EventsListView.firstHappening
        case .pressMe:
            return EventsListView.firstDetails
        case .swipeLeft:
            return "swipe left to modify"
        }
    }
}

protocol EventsListViewModelInput:
    EventsListViewModelInputState &
    EventsListViewModelInputEvents {}

class EventsListViewModel: EventsListViewModelInput {
    // MARK: - Properties
    weak var delegate: EventsListViewModelOutput?
    weak var coordinator: Coordinator?
    private var renamedEvent: Event?
    private var events: [Event]
    private let listUseCase: EventsListUseCaseInput
    private let editUseCase: EventEditUseCaseInput
    // MARK: - Init
    init(listUseCase: EventsListUseCaseInput,
         editUseCase: EventEditUseCaseInput)
    {
        self.events = listUseCase.allEvents()
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
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
        return .swipeLeft
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
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

extension EventsListViewModel: EventsListViewModelInputEvents {
    func select(event: Event) {
        coordinator?.showDetails(for: event)
    }

    func selectForRemoving(event: Event) {
        listUseCase.remove(event)
    }

    func selectForRenaming(event: Event) {
        renamedEvent = event
        delegate?.askNewName(withOldName: event.name)
    }

    func cancelNameEditing() { renamedEvent = nil }

    func submitNameEditing(name: String) {
        if let renamedEvent = renamedEvent {
            editUseCase.rename(renamedEvent, to: name)
        } else {
            listUseCase.add(name: name)
        }
    }
}

// MARK: - EventsListUseCaseOutput & EventEditUseCaseOutput
extension EventsListViewModel: EventsListUseCaseOutput, EventEditUseCaseOutput {
    func added(event: Event) {
        events = listUseCase.allEvents()

        if let index = events.firstIndex(of: event) {
            delegate?.addEvent(at: index)
        }

        delegate?.update()
    }

    func removed(event: Event) {
        if let index = events.firstIndex(of: event) {
            events = listUseCase.allEvents()
            delegate?.remove(at: index)
        }

        delegate?.update()
    }

    func updated(event: Event) {
        events = listUseCase.allEvents()

        if let index = events.firstIndex(of: event) {
            delegate?.update(at: index)
        }

        delegate?.update()
    }
}

protocol EventsListViewModelOutput: AnyObject {
    func update()
    func addEvent(at: Int)
    func remove(at: Int)
    func update(at: Int)
    func askNewName(withOldName: String)
}
