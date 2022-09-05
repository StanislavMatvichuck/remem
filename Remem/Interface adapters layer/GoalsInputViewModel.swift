//
//  GoalsInputViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import Foundation

protocol GoalsInputViewModeling:
    GoalsInputViewModelState &
    GoalsInputViewModelEvents {}

protocol GoalsInputViewModelState {
    func amount(forWeekDay: Goal.WeekDay) -> Int
}

protocol GoalsInputViewModelEvents {
    func select(weekday: Goal.WeekDay, value: Int)
    func submit()
    func cancel()
}

class GoalsInputViewModel: GoalsInputViewModeling {
    // MARK: - Properties
    weak var delegate: GoalsInputViewModelDelegate?
    weak var coordinator: Coordinator?
    private let event: Event
    private let editUseCase: EventEditUseCasing
    // MARK: - Init
    init(event: Event, editUseCase: EventEditUseCasing) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // GoalsInputViewModelState
    func amount(forWeekDay: Goal.WeekDay) -> Int {
        event.goals(at: forWeekDay).last?.amount ?? 0
    }

    // GoalsInputViewModelEvents
    func select(weekday: Goal.WeekDay, value: Int) {}

    func submit() {
        coordinator?.navController.dismiss(animated: true)
    }

    func cancel() {
        coordinator?.navController.dismiss(animated: true)
    }
}

protocol GoalsInputViewModelDelegate: AnyObject {}
