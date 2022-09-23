//
//  GoalsInputViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import Foundation
import Domain
import IosUseCases

public protocol GoalsInputViewModeling:
    GoalsInputViewModelState &
    GoalsInputViewModelEvents {}

public protocol GoalsInputViewModelState {
    func amount(forWeekDay: Goal.WeekDay) -> Int
}

public protocol GoalsInputViewModelEvents {
    func select(newAmount: Int, date: Date)
    func submit()
    func cancel()
}

public class GoalsInputViewModel: GoalsInputViewModeling {
    // MARK: - Properties
    public weak var delegate: GoalsInputViewModelDelegate?
    public weak var coordinator: Coordinating?

    private let event: Event
    private let goalEditUseCase: GoalEditUseCasing
    // MARK: - Init
    public init(event: Event, goalEditUseCase: GoalEditUseCasing) {
        self.event = event
        self.goalEditUseCase = goalEditUseCase
    }

    // GoalsInputViewModelState
    public func amount(forWeekDay: Goal.WeekDay) -> Int {
        event.goals(at: forWeekDay).last?.amount ?? 0
    }

    // GoalsInputViewModelEvents
    public func select(newAmount: Int, date: Date) {
        goalEditUseCase.update(amount: newAmount, forDate: date)
    }

    public func submit() {
        goalEditUseCase.submit()
        coordinator?.dismiss()
    }

    public func cancel() {
        goalEditUseCase.cancel()
        coordinator?.dismiss()
    }
}

public protocol GoalsInputViewModelDelegate: AnyObject {}
