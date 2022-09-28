//
//  GoalEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import Foundation
import Domain

public protocol GoalEditUseCasing {
    func submit()
    func cancel()
    func update(amount: Int, forDate: Date)
}

public class GoalEditUseCase: GoalEditUseCasing {
    // MARK: - Properties

    public weak var delegate: GoalEditUseCaseDelegate?
    let event: Event
    let eventEditUseCase: EventEditUseCasing

    private var state = [Goal.WeekDay: (Int, Date)]()
    // MARK: - Init
    public init(event: Event, eventEditUseCase: EventEditUseCasing) {
        self.event = event
        self.eventEditUseCase = eventEditUseCase
    }

    public func submit() {
        for weekday in state.keys {
            guard let (newGoalAmount, newGoalDate) = state[weekday] else { continue }
            eventEditUseCase.addGoal(to: event, at: newGoalDate, amount: newGoalAmount)
        }
    }

    public func cancel() { delegate?.dismiss() }

    public func update(amount: Int, forDate: Date) {
        let weekday = Goal.WeekDay.make(forDate)
        state.updateValue((amount, forDate), forKey: weekday)
        delegate?.update(amount: amount, forDay: Goal.WeekDay.make(forDate))
    }
}

public protocol GoalEditUseCaseDelegate: AnyObject {
    func update(amount: Int, forDay: Goal.WeekDay)
    func dismiss()
}
