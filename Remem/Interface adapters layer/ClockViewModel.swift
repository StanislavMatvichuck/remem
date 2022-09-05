//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Foundation

protocol ClockViewModelInput:
    ClockViewModelState &
    ClockViewModelEvents {}

protocol ClockViewModelState {
    func section(at: Int) -> ClockSection?
}

protocol ClockViewModelEvents {}

class ClockViewModel: ClockViewModelInput {
    weak var delegate: ClockViewModelOutput?
    private var event: Event { didSet {
        list = ClockSectionsList(happenings: event.happenings)
    }}

    private var list: ClockSectionsList
    // MARK: - Init
    init(event: Event) {
        self.event = event
        list = ClockSectionsList(happenings: event.happenings)
    }

    // ClockViewModelState
    func section(at: Int) -> ClockSection? {
        list.section(at: at)
    }
}

extension ClockViewModel: EventEditUseCaseOutput {
    func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    func added(goal: Goal, to: Event) {}
    func renamed(event: Event) {}
    func visited(event: Event) {}
}

protocol ClockViewModelOutput: AnyObject {
    func update()
}
