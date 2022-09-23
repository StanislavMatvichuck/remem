//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Foundation
import Domain
import IosUseCases

public protocol WeekCellViewModeling:
    WeekCellViewModelState &
    WeekCellViewModelEvents {}

public protocol WeekCellViewModelState {
    var goalsAmount: Int { get }
    var happeningsTimings: [String] { get }
    var isAchieved: Bool { get }
    var isToday: Bool { get }
    var dayNumber: String { get }
    var amount: String { get }
}

public protocol WeekCellViewModelEvents {
    func select()
}

public class WeekCellViewModel: WeekCellViewModeling {
    // MARK: - Properties
    public weak var delegate: WeekCellViewModelDelegate?
    public weak var coordinator: Coordinating?

    let date: Date
    let event: Event
    /// Used by GoalEditUseCase
    private var overriddenGoalsAmount: Int?
    // MARK: - Init
    public init(date: Date, event: Event) {
        self.date = date
        self.event = event
    }

    // WeekCellViewModelState
    public var dayNumber: String { String(Calendar.current.dateComponents([.day], from: date).day ?? 0) }
    public var isAchieved: Bool {
        if let overriddenGoalsAmount = overriddenGoalsAmount {
            if overriddenGoalsAmount == 0 { return false }
            return happeningsTimings.count >= overriddenGoalsAmount
        } else {
            return event.goal(at: date)?.isReached(at: date) ?? false
        }
    }

    public var amount: String { String(event.happenings(forDay: date).count) }
    public var goalsAmount: Int { overriddenGoalsAmount ?? event.goal(at: date)?.amount ?? 0 }

    public var isToday: Bool { Calendar.current.isDateInToday(date) }
    public var happeningsTimings: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return event.happenings(forDay: date).map { happening in
            formatter.string(from: happening.dateCreated)
        }
    }

    // WeekCellViewModelEvents
    public func select() { coordinator?.showDay(event: event, date: date) }
}

extension WeekCellViewModel: EventEditUseCaseDelegate {
    public func renamed(event: Event) { delegate?.update() }
    public func added(goal: Goal, to: Event) { delegate?.update() }
    public func added(happening: Happening, to: Event) { delegate?.update() }
    public func removed(happening: Happening, from: Event) { delegate?.update() }

    public func visited(event: Event) {}
}

// MARK: - GoalEditUseCaseDelegate
extension WeekCellViewModel: GoalEditUseCaseDelegate {
    public func update(amount: Int, forDay: Goal.WeekDay) {
        if Goal.WeekDay.make(date) == forDay {
            overriddenGoalsAmount = amount
            delegate?.highlightGoalSelection(amount: amount)
        }
    }

    public func dismiss() {
        overriddenGoalsAmount = nil
        delegate?.update()
    }
}

public protocol WeekCellViewModelDelegate: AnyObject {
    func update()
    func highlightGoalSelection(amount: Int)
}
