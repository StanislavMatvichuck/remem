//
//  EventsListViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Domain
import Foundation
import IosUseCases

protocol EventsListViewModeling:
    EventsListViewModelState &
    EventsListViewModelEvents {}

protocol EventsListViewModelState {
    var isAddButtonHighlighted: Bool { get }
    var hint: HintState { get }

    var count: Int { get }
    func event(at: Int) -> Event?
    func cellVM(at: Int) -> EventCellViewModel?
}

protocol EventsListViewModelEvents: AnyObject {
    func select(event: Event)
    func selectForRenaming(event: Event)
    func selectForRemoving(event: Event)
    func cancelNameEditing()
    func submitNameEditing(name: String)
}

class EventsListViewModel: EventsListViewModeling {
    // MARK: - Properties
    weak var delegate: EventsListViewModelDelegate?
    weak var coordinator: Coordinating?

    private let listUseCase: EventsListUseCasing
    private let editUseCase: EventEditUseCasing
    private let factory: EventsListFactoryInterface

    private var renamedEvent: Event?
    private var events: [Event]
    // MARK: - Init
    init(listUseCase: EventsListUseCasing,
         editUseCase: EventEditUseCasing,
         factory: EventsListFactoryInterface)
    {
        self.events = listUseCase.allEvents()
        self.factory = factory
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
    }

    // EventsListViewModelState
    var count: Int { events.count }
    var isAddButtonHighlighted: Bool { events.count == 0 }
    var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .swipeLeft
    }

    func cellVM(at index: Int) -> EventCellViewModel? {
        guard let event = event(at: index) else { return nil }
        let viewModel = factory.makeEventCellViewModel(event: event)
        return viewModel
    }

    func event(at index: Int) -> Event? {
        guard index < events.count, index >= 0 else { return nil }
        return events[index]
    }

    // EventsListViewModelEvents
    func select(event: Event) { coordinator?.showDetails(event: event) }
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

// MARK: - EventsListUseCaseDelegate & EventEditUseCasingDelegate
extension EventsListViewModel: EventsListUseCasingDelegate, EventEditUseCasingDelegate {
    // EventsListUseCaseDelegate
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

    // EventEditUseCasingDelegate
    func added(happening: Happening, to: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    func visited(event: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {
        events = listUseCase.allEvents()
        delegate?.update()
    }

    func renamed(event: Event) {}
    func added(goal: Goal, to: Event) {}
}

// MARK: - EventsListViewModelDelegate
protocol EventsListViewModelDelegate: AnyObject {
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
