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

    private var weekDay: WeekDay

    // MARK: - Init
    init(weekDay: WeekDay) {
        self.weekDay = weekDay

        goalsAmount = weekDay.goal?.amount ?? 0

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        happeningsTimings = weekDay.happenings.map { happening in
            formatter.string(from: happening.dateCreated)
        }

        isAchieved = happeningsTimings.count >= goalsAmount && goalsAmount > 0
        isToday = weekDay.isToday
        amount = String(weekDay.happenings.count)
        dayNumber = String(weekDay.dayNumber)
    }

    // WeekCellViewModelState
    var goalsAmount: Int
    var happeningsTimings: [String]
    var isAchieved: Bool
    var isToday: Bool
    var amount: String
    var dayNumber: String

    // WeekCellViewModelEvents
    func select() {
        print(#function)
    }
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
