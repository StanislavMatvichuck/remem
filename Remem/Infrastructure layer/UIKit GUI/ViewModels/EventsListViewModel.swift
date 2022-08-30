//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Foundation

protocol EventsListViewModelInput:
    EventsListViewModelInputState &
    EventsListViewModelInputEvents {}

protocol EventsListViewModelInputState {
    var isAddButtonHighlighted: Bool { get }
    var hint: HintState { get }
    var eventsAmount: Int { get }
    func event(at: IndexPath) -> Event?
}

protocol EventsListViewModelInputEvents: AnyObject {
    func select(event: Event)
    func selectForRenaming(event: Event)
    func selectForRemoving(event: Event)
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

class EventsListViewModel: EventsListViewModelInput {
    // MARK: - Properties
    weak var delegate: EventsListViewModelOutput?
    weak var coordinator: Coordinator?

    private let listUseCase: EventsListUseCaseInput
    private let editUseCase: EventEditUseCaseInput

    private var renamedEvent: Event?
    private var events: [Event]
    // MARK: - Init
    init(listUseCase: EventsListUseCaseInput,
         editUseCase: EventEditUseCaseInput)
    {
        self.events = listUseCase.allEvents()
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
    }

    // EventsListViewModelInputState
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

    // EventsListViewModelInputEvents
    func select(event: Event) { coordinator?.showDetails(for: event) }
    func cancelNameEditing() { renamedEvent = nil }
    func selectForRemoving(event: Event) { listUseCase.remove(event) }
    func selectForRenaming(event: Event) {
        renamedEvent = event
        delegate?.askNewName(withOldName: event.name)
    }

    func submitNameEditing(name: String) {
        if let renamedEvent = renamedEvent {
            editUseCase.rename(renamedEvent, to: name)
        } else {
            listUseCase.add(name: name)
        }
    }
}

// MARK: - EventsListUseCaseOutput
extension EventsListViewModel: EventsListUseCaseOutput {
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
}

protocol EventsListViewModelOutput: AnyObject {
    func update()
    func addEvent(at: Int)
    func remove(at: Int)
    func update(at: Int)
    func askNewName(withOldName: String)
}

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
