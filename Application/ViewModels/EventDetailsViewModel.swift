//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation
import IosUseCases

public protocol EventDetailsViewModeling:
    EventDetailsViewModelState &
    EventDetailsViewModelEvents {}

public protocol EventDetailsViewModelState {
    var totalAmount: String { get }
    var dayAverage: String { get }
}

public protocol EventDetailsViewModelEvents {
    func showGoalsInput()
    func visitIfNeeded()
}

public class EventDetailsViewModel: EventDetailsViewModeling {
    public weak var delegate: EventDetailsViewModelDelegate?
    public weak var coordinator: Coordinating?

    private let event: Event
    private let editUseCase: EventEditUseCasing

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    public init(event: Event, editUseCase: EventEditUseCasing) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // EventDetailsViewModelState
    public var totalAmount: String {
        String(event.happenings.reduce(0) { partialResult, happening in
            partialResult + Int(happening.value)
        })
    }

    public var dayAverage: String {
        let total = Double(totalAmount)
        let daysAmount = Double(daysSince)
        let number = NSNumber(value: total! / daysAmount)
        return formatter.string(from: number)!
    }

    private var daysSince: Int {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: event.dateCreated)
        let toDate = cal.startOfDay(for: Date())
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
        return numberOfDays + 1
    }

    // EventDetailsViewModelEvents
    public func showGoalsInput() { coordinator?.showGoalsInput(event: event, callingViewModel: self) }
    public func visitIfNeeded() {
        if event.dateVisited == nil { editUseCase.visit(event) }
    }
}

extension EventDetailsViewModel: EventEditUseCasingDelegate {
    public func added(happening: Happening, to: Event) {
        delegate?.update()
    }

    public func removed(happening: Happening, from: Event) {}
    public func renamed(event: Event) {}
    public func visited(event: Event) {}
    public func added(goal: Goal, to: Event) {}
}

public protocol EventDetailsViewModelDelegate: AnyObject {
    func update()
}
