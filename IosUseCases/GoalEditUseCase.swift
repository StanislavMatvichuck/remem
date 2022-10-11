//
//  GoalEditUseCase.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import Domain
import Foundation

public protocol GoalEditUseCasing {
    func submit()
    func cancel()
    func update(amount: Int, forDate: Date)

    func add(delegate: GoalEditUseCasingDelegate)
    func remove(delegate: GoalEditUseCasingDelegate)
}

public class GoalEditUseCase: GoalEditUseCasing {
    // MARK: - Properties
    private let event: Event
    private let eventEditUseCase: EventEditUseCasing
    private let delegates: MulticastDelegate<GoalEditUseCasingDelegate>

    private var state = [WeekDay: (Int, Date)]()
    // MARK: - Init
    public init(event: Event, eventEditUseCase: EventEditUseCasing) {
        self.event = event
        self.eventEditUseCase = eventEditUseCase
        self.delegates = MulticastDelegate<GoalEditUseCasingDelegate>()
    }

    public func submit() {
        for weekday in state.keys {
            guard let (newGoalAmount, newGoalDate) = state[weekday] else { continue }
            eventEditUseCase.addGoal(to: event, at: newGoalDate, amount: newGoalAmount)
        }
    }

    public func cancel() { delegates.call { $0.dismiss() } }

    public func update(amount: Int, forDate: Date) {
        let weekday = WeekDay.make(forDate)
        state.updateValue((amount, forDate), forKey: weekday)
        delegates.call { $0.update(amount: amount, forDay: WeekDay.make(forDate)) }
    }

    public func add(delegate: GoalEditUseCasingDelegate) { delegates.addDelegate(delegate) }
    public func remove(delegate: GoalEditUseCasingDelegate) { delegates.removeDelegate(delegate) }
}

public protocol GoalEditUseCasingDelegate: AnyObject {
    func update(amount: Int, forDay: WeekDay)
    func dismiss()
}
