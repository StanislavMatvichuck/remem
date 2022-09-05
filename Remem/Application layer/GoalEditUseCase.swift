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
    weak var delegate: GoalEditUseCaseDelegate?

    let event: Event
    let eventEditUseCase: EventEditUseCasing
    // MARK: - Init
    init(event: Event, eventEditUseCase: EventEditUseCasing) {
        self.event = event
        self.eventEditUseCase = eventEditUseCase
    }

    func submit() {
        print("submit")
    }

    func cancel() {
        print("cancel")
    }

    func update(amount: Int, forDate: Date) {
        print("amount \(amount) forDate \(forDate)")
        delegate?.update(amount: amount, forDay: .make(forDate))
    }
}

protocol GoalEditUseCaseDelegate: AnyObject {
    func update(amount: Int, forDay: Goal.WeekDay)
}
