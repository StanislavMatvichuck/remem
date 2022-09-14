//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Foundation
import RememDomain

public protocol ClockViewModeling:
    ClockViewModelState &
    ClockViewModelEvents {}

public protocol ClockViewModelState {
    func section(at: Int) -> ClockSection?
}

public protocol ClockViewModelEvents {}

public class ClockViewModel: ClockViewModeling {
    public weak var delegate: ClockViewModelDelegate?
    private var event: Event { didSet {
        list = ClockSectionsList(happenings: event.happenings)
    }}

    private var list: ClockSectionsList
    // MARK: - Init
    public init(event: Event) {
        self.event = event
        list = ClockSectionsList(happenings: event.happenings)
    }

    // ClockViewModelState
    public func section(at: Int) -> ClockSection? {
        list.section(at: at)
    }
}

extension ClockViewModel: EventEditUseCaseDelegate {
    public func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    public func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    public func added(goal: Goal, to: Event) {}
    public func renamed(event: Event) {}
    public func visited(event: Event) {}
}

public protocol ClockViewModelDelegate: AnyObject {
    func update()
}
