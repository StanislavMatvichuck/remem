//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Foundation

protocol WeekCellViewModelInput:
    WeekCellViewModelState &
    WeekCellViewModelEvents {}

protocol WeekCellViewModelState {
    var goalsAmount: Int { get }
    var happeningsTimings: [String] { get }
    var isAchieved: Bool { get }
    var isToday: Bool { get }
    var dayNumber: String { get }
    var amount: String { get }
}

protocol WeekCellViewModelEvents {
    func select()
}

class WeekCellViewModel: WeekCellViewModelInput {
    // MARK: - Properties
    weak var delegate: WeekCellViewModelOutput?
    weak var coordinator: Coordinator?

    let date: Date
    let event: Event
    // MARK: - Init
    init(date: Date, event: Event) {
        self.date = date
        self.event = event
    }

    // WeekCellViewModelState
    var dayNumber: String { String(Calendar.current.dateComponents([.day], from: date).day ?? 0) }
    var isAchieved: Bool { event.happenings(forDay: date).count >= goalsAmount && goalsAmount > 0 }
    var amount: String { String(event.happenings(forDay: date).count) }
    var goalsAmount: Int { event.goal(at: date)?.amount ?? 0 }
    var isToday: Bool { Calendar.current.isDateInToday(date) }
    var happeningsTimings: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return event.happenings(forDay: date).map { happening in
            formatter.string(from: happening.dateCreated)
        }
    }

    // WeekCellViewModelEvents
    func select() { coordinator?.showDayController(date: date, event: event) }
}

extension WeekCellViewModel: EventEditUseCaseOutput {
    func renamed(event: Event) { delegate?.update() }
    func added(goal: Goal, to: Event) { delegate?.update() }
    func added(happening: Happening, to: Event) { delegate?.update() }
    func removed(happening: Happening, from: Event) { delegate?.update() }

    func visited(event: Event) {}
}

protocol WeekCellViewModelOutput: AnyObject {
    func update()
}
