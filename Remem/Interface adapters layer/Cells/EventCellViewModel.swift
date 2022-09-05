//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation

protocol EventCellViewModeling:
    EventCellViewModelingState &
    EventCellViewModelingEvents {}

protocol EventCellViewModelingState {
    var name: String { get }
    var amount: String { get }
}

protocol EventCellViewModelingEvents {
    func select()
    func swipe()
}

class EventCellViewModel: EventCellViewModeling {
    // MARK: - Properties
    weak var coordinator: Coordinating?
    weak var delegate: EventCellViewModelDelegate?

    private let event: Event
    private let editUseCase: EventEditUseCasing
    private var renamedEvent: Event?
    // MARK: - Init
    init(event: Event, editUseCase: EventEditUseCasing) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // EventCellViewModelingState
    var name: String { event.name }
    var amount: String { String(event.happenings.count) }

    // EventCellViewModelingEvents
    func select() { coordinator?.showDetails(event: event) }
    func swipe() { editUseCase.addHappening(to: event, date: .now) }
}

// MARK: - EventEditUseCaseDelegate
extension EventCellViewModel: EventEditUseCaseDelegate {
    func added(happening: Happening, to: Event) {
        guard event == to else { return }
        delegate?.addedHappening()
    }

    func removed(happening: Happening, from: Event) {}
    func renamed(event: Event) {}
    func visited(event: Event) {}
    func added(goal: Goal, to: Event) {}
}

// MARK: - EventCellViewModelDelegate
protocol EventCellViewModelDelegate: AnyObject {
    func addedHappening()
}
