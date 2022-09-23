//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation
import Domain
import IosUseCases

public protocol EventCellViewModeling:
    EventCellViewModelingState &
    EventCellViewModelingEvents {}

public protocol EventCellViewModelingState {
    var name: String { get }
    var amount: String { get }
    var hasGoal: Bool { get }
    var goalReached: Bool { get }
}

public protocol EventCellViewModelingEvents {
    func select()
    func swipe()
}

public class EventCellViewModel: EventCellViewModeling {
    // MARK: - Properties
    public weak var coordinator: Coordinating?
    public weak var delegate: EventCellViewModelDelegate?

    private let event: Event
    private let editUseCase: EventEditUseCasing
    private var renamedEvent: Event?
    // MARK: - Init
    public init(event: Event, editUseCase: EventEditUseCasing) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // EventCellViewModelingState
    public var name: String { event.name }
    public var amount: String {
        let todayDate = Date.now
        let todayHappeningsCount = event.happenings(forDay: todayDate).count
        if let todayGoal = event.goal(at: todayDate), todayGoal.amount > 0 {
            return "\(todayHappeningsCount)/\(todayGoal.amount)"
        } else {
            return "\(todayHappeningsCount)"
        }
    }

    public var hasGoal: Bool {
        let todayDate = Date.now
        if let goal = event.goal(at: todayDate) {
            return goal.amount > 0
        }
        return false
    }

    public var goalReached: Bool {
        let todayDate = Date.now
        return event.goal(at: todayDate)?.isReached(at: todayDate) ?? false
    }

    // EventCellViewModelingEvents
    public func select() { coordinator?.showDetails(event: event) }
    public func swipe() { editUseCase.addHappening(to: event, date: .now) }
}

// MARK: - EventEditUseCaseDelegate
extension EventCellViewModel: EventEditUseCaseDelegate {
    public func added(happening: Happening, to: Event) {
        guard event == to else { return }
        delegate?.addedHappening()
    }

    public func removed(happening: Happening, from: Event) {
        guard event == from else { return }
        delegate?.removedHappening()
    }

    public func renamed(event: Event) {
        guard self.event == event else { return }
        delegate?.renamed()
    }

    public func visited(event: Event) {}
    public func added(goal: Goal, to: Event) {
        guard event == to else { return }
        delegate?.addedHappening()
    }
}

// MARK: - EventCellViewModelDelegate
public protocol EventCellViewModelDelegate: AnyObject {
    func removedHappening()
    func addedHappening()
    func addedGoal()
    func renamed()
}
