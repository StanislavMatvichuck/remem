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
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    // MARK: - Init
    public init(event: Event) {
        self.event = event
    }

    // WeekSummaryViewModelState
    public func total(at: Date) -> String {
        return "0"
    }

    public func goalAmount(at: Date) -> String {
        "0"
    }
}

// MARK: - Private
extension WeekSummaryViewModel {
    private func totalAtWeek(previousToCurrent: Int) -> Int {
        var result = 0

        for happening in event.happenings {
            let weekOffset = Date.now.days(ago: 7 * previousToCurrent)
            if weekOffset.isInSameWeek(as: happening.dateCreated) {
                result += Int(happening.value)
            }
        }

        return result
    }

    private var weekAverage: String {
        var weeksTotals: [Double] = []

        for i in 0 ... weeksSince - 1 {
            let totalAtWeek = Double(totalAtWeek(previousToCurrent: i))
            weeksTotals.append(totalAtWeek)
        }

        let total: Double = weeksTotals.reduce(0) { result, iterationAverage in
            result + iterationAverage
        }
        let number = NSNumber(value: total / Double(weeksTotals.count))
        return formatter.string(from: number)!
    }

    private var weeksSince: Int {
        var iterationDate = Date.now
        var result = 1

        while !iterationDate.isInSameWeek(as: event.dateCreated) {
            iterationDate = iterationDate.days(ago: 7)
            result += 1
        }

        return result
    }
}

// MARK: - EventEditUseCasingDelegate
extension WeekSummaryViewModel: EventEditUseCasingDelegate {
    public func update(event: Event) {
        self.event = event
        delegate?.updateTotalAmount()
    }
}

public protocol WeekSummaryViewModelDelegate: AnyObject {
    func updateGoalAmount()
    func updateTotalAmount()
}
