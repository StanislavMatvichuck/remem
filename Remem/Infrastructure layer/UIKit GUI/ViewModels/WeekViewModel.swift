//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

protocol WeekViewModelInput:
    WeekViewModelState &
    WeekViewModelEvents {}

protocol WeekViewModelState {
    var happeningsList: WeekList { get }
    var shownDaysForward: Int { get }
}

protocol WeekViewModelEvents {
    func select(day: DateComponents)
}

class WeekViewModel: WeekViewModelInput {
    // MARK: - Properties
    weak var delegate: WeekViewModelOutput?
    weak var coordinator: Coordinator?

    private var event: Event { didSet { happeningsList = WeekList(event: event) }}

    // MARK: - Init
    init(event: Event) {
        self.event = event
        happeningsList = WeekList(event: event)
    }

    // WeekViewModelState
    var happeningsList: WeekList
    var shownDaysForward: Int { happeningsList.shownDaysForward }

    // WeekViewModelEvents
    func select(day: DateComponents) {
        coordinator?.showDayController(for: day, event: event)
    }
}

// MARK: - EventEditUseCaseOutput
extension WeekViewModel: EventEditUseCaseOutput {
    func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    func added(goal: Goal, to: Event) {
        event = to
        delegate?.update()
    }

    func renamed(event: Event) {}
    func visited(event: Event) {}
}

protocol WeekViewModelOutput: AnyObject {
    func animate(at: IndexPath)
    func update()
}
