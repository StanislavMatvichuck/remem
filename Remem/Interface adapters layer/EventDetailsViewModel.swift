//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Foundation

protocol EventDetailsViewModeling:
    EventDetailsViewModelState &
    EventDetailsViewModelEvents {}

protocol EventDetailsViewModelState {
    var totalAmount: String { get }
    var dayAverage: String { get }
    var thisWeekTotal: String { get }
    var lastWeekTotal: String { get }
    var weekAverage: String { get }
}

protocol EventDetailsViewModelEvents {
    func showGoalsInput()
    func visitIfNeeded()
}

class EventDetailsViewModel: EventDetailsViewModeling {
    weak var delegate: EventDetailsViewModelDelegate?
    weak var coordinator: Coordinating?

    private let event: Event
    private let editUseCase: EventEditUseCasing

    init(event: Event, editUseCase: EventEditUseCasing) {
        self.event = event
        self.editUseCase = editUseCase
    }

    // EventDetailsViewModelState
    var thisWeekTotal: String { String(totalAtWeek(previousToCurrent: 0)) }
    var lastWeekTotal: String { String(totalAtWeek(previousToCurrent: 1)) }
    var totalAmount: String {
        String(event.happenings.reduce(0) { partialResult, happening in
            partialResult + Int(happening.value)
        })
    }

    var dayAverage: String {
        let total = Double(totalAmount)
        let daysAmount = Double(daysSince)
        return String(total! / daysAmount)
    }

    var weekAverage: String {
        var weeksTotals: [Double] = []

        for i in 0 ... weeksSince - 1 {
            let totalAtWeek = Double(totalAtWeek(previousToCurrent: i))
            weeksTotals.append(totalAtWeek)
        }

        let total: Double = weeksTotals.reduce(0) { result, iterationAverage in
            result + iterationAverage
        }

        return String(total / Double(weeksTotals.count))
    }

    private var daysSince: Int {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: event.dateCreated)
        let toDate = cal.startOfDay(for: Date())
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
        return numberOfDays + 1
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

    // EventDetailsViewModelEvents
    func showGoalsInput() { coordinator?.showGoalsInput(event: event, callingViewModel: self) }
    func visitIfNeeded() {
        if event.dateVisited == nil { editUseCase.visit(event) }
    }
}

extension EventDetailsViewModel: EventEditUseCaseDelegate {
    func added(happening: Happening, to: Event) {
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {}
    func renamed(event: Event) {}
    func visited(event: Event) {}
    func added(goal: Goal, to: Event) {}
}

protocol EventDetailsViewModelDelegate: AnyObject {
    func update()
}
