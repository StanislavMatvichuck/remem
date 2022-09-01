//
//  GoalsInputViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import Foundation

protocol GoalsInputViewModelInput:
    GoalsInputViewModelState &
    GoalsInputViewModelEvents {}

protocol GoalsInputViewModelState {
    var values: [Goal.WeekDay: Int] { get }
}

protocol GoalsInputViewModelEvents {
    func select(weekday: Goal.WeekDay, value: Int)
    func submit()
    func cancel()
}

class GoalsInputViewModel: GoalsInputViewModelInput {
    // MARK: - Properties
    private let event: Event
    weak var delegate: GoalsInputViewModelOutput?

    // MARK: - Init
    init(event: Event) { self.event = event }

    // GoalsInputViewModelState
    var values: [Goal.WeekDay: Int] = [:]
    // GoalsInputViewModelEvents
    func select(weekday: Goal.WeekDay, value: Int) {}
    func submit() {}
    func cancel() {}
}

protocol GoalsInputViewModelOutput: AnyObject {}
