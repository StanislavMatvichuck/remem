//
//  GoalsInputViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import Foundation
import RememDomain

protocol GoalsInputViewModeling:
    GoalsInputViewModelState &
    GoalsInputViewModelEvents {}

protocol GoalsInputViewModelState {
    func amount(forWeekDay: Goal.WeekDay) -> Int
}

protocol GoalsInputViewModelEvents {
    func select(newAmount: Int, date: Date)
    func submit()
    func cancel()
}

class GoalsInputViewModel: GoalsInputViewModeling {
    // MARK: - Properties
    weak var delegate: GoalsInputViewModelDelegate?
    weak var coordinator: Coordinator?

    private let event: Event
    private let goalEditUseCase: GoalEditUseCasing
    // MARK: - Init
    init(event: Event, goalEditUseCase: GoalEditUseCasing) {
        self.event = event
        self.goalEditUseCase = goalEditUseCase
    }

    // GoalsInputViewModelState
    func amount(forWeekDay: Goal.WeekDay) -> Int {
        event.goals(at: forWeekDay).last?.amount ?? 0
    }

    // GoalsInputViewModelEvents
    func select(newAmount: Int, date: Date) {
        goalEditUseCase.update(amount: newAmount, forDate: date)
    }

    func submit() {
        goalEditUseCase.submit()
        coordinator?.navController.dismiss(animated: true)
    }

    func cancel() {
        goalEditUseCase.cancel()
        coordinator?.navController.dismiss(animated: true)
    }
}

protocol GoalsInputViewModelDelegate: AnyObject {}
