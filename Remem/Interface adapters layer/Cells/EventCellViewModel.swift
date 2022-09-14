//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation
import RememDomain

protocol EventCellViewModeling:
    EventCellViewModelingState &
    EventCellViewModelingEvents {}

protocol EventCellViewModelingState {
    var name: String { get }
    var amount: String { get }
    var hasGoal: Bool { get }
    var goalReached: Bool { get }
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
    var amount: String {
        let todayDate = Date.now
        let todayHappeningsCount = event.happenings(forDay: todayDate).count
        if let todayGoal = event.goal(at: todayDate), todayGoal.amount > 0 {
            return "\(todayHappeningsCount)/\(todayGoal.amount)"
        } else {
            return "\(todayHappeningsCount)"
        }
    }

    var hasGoal: Bool {
        let todayDate = Date.now
        if let goal = event.goal(at: todayDate) {
            return goal.amount > 0
        }
        return false
    }

    var goalReached: Bool {
        let todayDate = Date.now
        return event.goal(at: todayDate)?.isReached(at: todayDate) ?? false
    }

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

    func removed(happening: Happening, from: Event) {
        guard event == from else { return }
        delegate?.removedHappening()
    }

    func renamed(event: Event) {
        guard self.event == event else { return }
        delegate?.renamed()
    }

    func visited(event: Event) {}
    func added(goal: Goal, to: Event) {
        guard event == to else { return }
        delegate?.addedHappening()
    }
}

// MARK: - EventCellViewModelDelegate
protocol EventCellViewModelDelegate: AnyObject {
    func removedHappening()
    func addedHappening()
    func addedGoal()
    func renamed()
}
