//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Foundation
import RememDomain

protocol WeekCellViewModeling:
    WeekCellViewModelState &
    WeekCellViewModelEvents {}

protocol WeekCellViewModelState {
    var goalsAmount: Int { get }
    var happeningsTimings: [String] { get }
    var isAchieved: Bool { get }
    var isToday: Bool { get }
    var dayNumber: String { get }
    var amount: String { get }
}

protocol WeekCellViewModelEvents {
    func select()
}

class WeekCellViewModel: WeekCellViewModeling {
    // MARK: - Properties
    weak var delegate: WeekCellViewModelDelegate?
    weak var coordinator: Coordinating?

    let date: Date
    let event: Event
    /// Used by GoalEditUseCase
    private var overriddenGoalsAmount: Int?
    // MARK: - Init
    init(date: Date, event: Event) {
        self.date = date
        self.event = event
    }

    // WeekCellViewModelState
    var dayNumber: String { String(Calendar.current.dateComponents([.day], from: date).day ?? 0) }
    var isAchieved: Bool {
        if let overriddenGoalsAmount = overriddenGoalsAmount {
            if overriddenGoalsAmount == 0 { return false }
            return happeningsTimings.count >= overriddenGoalsAmount
        } else {
            return event.goal(at: date)?.isReached(at: date) ?? false
        }
    }

    var amount: String { String(event.happenings(forDay: date).count) }
    var goalsAmount: Int { overriddenGoalsAmount ?? event.goal(at: date)?.amount ?? 0 }

    var isToday: Bool { Calendar.current.isDateInToday(date) }
    var happeningsTimings: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return event.happenings(forDay: date).map { happening in
            formatter.string(from: happening.dateCreated)
        }
    }

    // WeekCellViewModelEvents
    func select() { coordinator?.showDay(event: event, date: date) }
}

extension WeekCellViewModel: EventEditUseCaseDelegate {
    func renamed(event: Event) { delegate?.update() }
    func added(goal: Goal, to: Event) { delegate?.update() }
    func added(happening: Happening, to: Event) { delegate?.update() }
    func removed(happening: Happening, from: Event) { delegate?.update() }

    func visited(event: Event) {}
}

// MARK: - GoalEditUseCaseDelegate
extension WeekCellViewModel: GoalEditUseCaseDelegate {
    func update(amount: Int, forDay: Goal.WeekDay) {
        if Goal.WeekDay.make(date) == forDay {
            overriddenGoalsAmount = amount
            delegate?.highlightGoalSelection(amount: amount)
        }
    }

    func dismiss() {
        overriddenGoalsAmount = nil
        delegate?.update()
    }
}

protocol WeekCellViewModelDelegate: AnyObject {
    func update()
    func highlightGoalSelection(amount: Int)
}
