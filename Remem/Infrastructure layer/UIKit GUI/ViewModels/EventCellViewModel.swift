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

protocol EventCellViewModelInputState {
    var name: String { get }
    var amount: String { get }
}

protocol EventCellViewModelInputEvents {
    func select()
    func swipe()
}

class EventCellViewModel: EventCellViewModelInput {
    // MARK: - Properties
    weak var coordinator: Coordinator?
    weak var delegate: EventCellViewModelOutput?

    private let event: Event
    private let editUseCase: EventEditUseCaseInput
    private var renamedEvent: Event?
    // MARK: - Init
    init(event: Event, editUseCase: EventEditUseCaseInput) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // EventCellViewModelInputState
    var name: String { event.name }
    var amount: String { String(event.happenings.count) }

    // EventCellViewModelInputEvents
    func select() { coordinator?.showDetails(for: event) }
    func swipe() { editUseCase.addHappening(to: event, date: .now) }
}

// MARK: - EventEditUseCaseOutput
extension EventCellViewModel: EventEditUseCaseOutput {
    func added(happening: Happening, to: Event) {
        guard event == to else { return }
        delegate?.addedHappening()
    }

    func removed(happening: Happening, from: Event) { fatalError("Missing implementation") }
    func renamed(event: Event) { fatalError("Missing implementation") }
    func visited(event: Event) { fatalError("Missing implementation") }
    func added(goal: Goal, to: Event) { fatalError("Missing implementation") }
}

// MARK: - EventCellVMOutput
protocol EventCellViewModelOutput: AnyObject {
    func addedHappening()
}
