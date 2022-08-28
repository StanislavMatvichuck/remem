//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation

protocol EventCellVMInput:
    EventCellVMInputState &
    EventCellVMInputEvents {}

class EventCellViewModel: EventCellVMInput {
    // MARK: - Properties
    weak var coordinator: Coordinator? { didSet { print("coordinator assigned to \(coordinator)") } }
    weak var delegate: EventCellVMOutput?

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
protocol EventCellVMInputState {
    var name: String { get }
    var amount: String { get }
}

extension EventCellViewModel: EventCellVMInputState {
    var name: String { event.name }
    var amount: String { String(event.happenings.count) }
}

protocol EventCellVMInputEvents {
    func select()
    func swipe()
}

// MARK: - EventCellVMInputEvents
extension EventCellViewModel: EventCellVMInputEvents {
    func select() {
        coordinator?.showDetails(for: event)
    }

    func swipe() {
        editUseCase.addHappening(to: event, date: .now)
    }
}

// MARK: - EventCellVMOutput
protocol EventCellVMOutput: AnyObject {
    func update()
}
