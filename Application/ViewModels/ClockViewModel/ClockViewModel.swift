//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation
import IosUseCases

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

extension ClockViewModel: EventEditUseCasingDelegate {
    public func update(event: Event) {
        self.event = event
        delegate?.update()
    }
}

public protocol ClockViewModelDelegate: AnyObject {
    func update()
}
