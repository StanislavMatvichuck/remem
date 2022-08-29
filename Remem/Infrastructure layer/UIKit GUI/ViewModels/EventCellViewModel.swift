//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation

protocol EventCellViewModelInput:
    EventCellViewModelInputState &
    EventCellViewModelInputEvents {}

class EventCellViewModel: EventCellViewModelInput {
    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var delegate: EventCellViewModelOutput?

    private var renamedEvent: Event?
    private let event: Event
    private let editUseCase: EventEditUseCaseInput
    // MARK: - Init
    init(event: Event, editUseCase: EventEditUseCaseInput) {
        self.event = event
        self.editUseCase = editUseCase
    }
}

// MARK: - EventCellVMInputState
protocol EventCellViewModelInputState {
    var name: String { get }
    var amount: String { get }
}

extension EventCellViewModel: EventCellViewModelInputState {
    var name: String { event.name }
    var amount: String { String(event.happenings.count) }
}

protocol EventCellViewModelInputEvents {
    func select()
    func swipe()
}

// MARK: - EventCellVMInputEvents
extension EventCellViewModel: EventCellViewModelInputEvents {
    func select() {
        coordinator?.showDetails(for: event)
    }

    func swipe() {
        editUseCase.addHappening(to: event, date: .now)
    }
}

// MARK: - EventEditUseCaseOutput
extension EventCellViewModel: EventEditUseCaseOutput {
    func updated(event: Event) { delegate?.update() }
}

// MARK: - EventCellVMOutput
protocol EventCellViewModelOutput: AnyObject {
    func update()
}
