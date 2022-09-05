//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Foundation

protocol DayViewModeling:
    DayViewModelState &
    DayViewModelEvents {}

protocol DayViewModelState {
    var title: String? { get }
    var date: Date { get }
    func time(at: Int) -> String
    var count: Int { get }
}

protocol DayViewModelEvents {
    func remove(at: Int)
    func add(at: Date)
}

class DayViewModel: DayViewModeling {
    // MARK: - Properties
    weak var delegate: DayViewModelDelegate?

    let date: Date
    private var event: Event
    private let editUseCase: EventEditUseCasing
    private var shownHappenings: [Happening] { event.happenings(forDay: date) }
    // MARK: - Init
    init(date: Date, event: Event, editUseCase: EventEditUseCasing) {
        self.date = date
        self.event = event
        self.editUseCase = editUseCase
    }

    // DayViewModelState
    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(for: date)
    }

    var count: Int { shownHappenings.count }

    func time(at: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happeningDate = shownHappenings[at].dateCreated
        return dateFormatter.string(from: happeningDate)
    }

    // DayViewModelEvents
    func remove(at: Int) {
        // this consist of error in time by day
        let happening = event.happenings(forDay: date)[at]
        editUseCase.removeHappening(from: event, happening: happening)
    }

    func add(at: Date) {
        editUseCase.addHappening(to: event, date: at)
    }
}

extension DayViewModel: EventEditUseCaseDelegate {
    func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    func renamed(event: Event) {}
    func visited(event: Event) {}
    func added(goal: Goal, to: Event) {}
}

protocol DayViewModelDelegate: AnyObject {
    func update()
}
