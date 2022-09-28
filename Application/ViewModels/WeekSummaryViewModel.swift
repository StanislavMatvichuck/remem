//
//  WeekSummaryViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.09.2022.
//

import Domain
import Foundation
import IosUseCases

public protocol WeekSummaryViewModeling:
    WeekSummaryViewModelState &
    WeekSummaryViewModelEvents {}

public protocol WeekSummaryViewModelState {
    func total(at: Date) -> String
    func goalAmount(at: Date) -> String
}

public protocol WeekSummaryViewModelEvents {}

public class WeekSummaryViewModel: WeekSummaryViewModeling {
    public weak var delegate: WeekSummaryViewModelDelegate?

    private var event: Event

    // MARK: - Init
    public init(event: Event) {
        self.event = event
    }

    // WeekSummaryViewModelState
    public func total(at: Date) -> String {
        "0"
    }

    public func goalAmount(at: Date) -> String {
        "0"
    }
}

extension WeekSummaryViewModel: EventEditUseCaseDelegate {
    public func added(happening: Happening, to: Event) {
        event = to
        delegate?.updateTotalAmount()
    }

    public func removed(happening: Happening, from: Event) {
        event = from
        delegate?.updateTotalAmount()
    }

    public func added(goal: Goal, to: Event) {
        delegate?.updateGoalAmount()
    }

    public func renamed(event: Event) {}
    public func visited(event: Event) {}
}

public protocol WeekSummaryViewModelDelegate: AnyObject {
    func updateGoalAmount()
    func updateTotalAmount()
}
