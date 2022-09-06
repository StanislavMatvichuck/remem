//
//  GoalEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import Foundation

protocol GoalEditUseCasing {
    func submit()
    func cancel()
    func update(amount: Int, forDate: Date)
}

class GoalEditUseCase: GoalEditUseCasing {
    // MARK: - Properties

    let delegates = MulticastDelegate<GoalEditUseCaseDelegate>()
    let event: Event
    let eventEditUseCase: EventEditUseCasing

    private var state = [Goal.WeekDay: (Int, Date)]()
    // MARK: - Init
    init(event: Event, eventEditUseCase: EventEditUseCasing) {
        self.event = event
        self.eventEditUseCase = eventEditUseCase
    }

    func submit() {
        for weekday in state.keys {
            guard let (newGoalAmount, newGoalDate) = state[weekday] else { continue }
            eventEditUseCase.addGoal(to: event, at: newGoalDate, amount: newGoalAmount)
        }
    }

    func cancel() { delegates.call { $0.dismiss() } }

    func update(amount: Int, forDate: Date) {
        let weekday = Goal.WeekDay.make(forDate)
        state.updateValue((amount, forDate), forKey: weekday)
        delegates.call { $0.update(amount: amount, forDay: .make(forDate)) }
    }
}

protocol GoalEditUseCaseDelegate: AnyObject {
    func update(amount: Int, forDay: Goal.WeekDay)
    func dismiss()
}
