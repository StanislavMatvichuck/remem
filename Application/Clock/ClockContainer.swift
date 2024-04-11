//
//  ClockContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class ClockContainer:
    ClockViewModelFactoring
{
    let clockSize = 64
    let parent: EventDetailsContainer
    let type: ClockViewModel.ClockType

    var event: Event { parent.event }

    init(parent: EventDetailsContainer, type: ClockViewModel.ClockType) {
        self.parent = parent
        self.type = type
    }

    func make() -> UIViewController { ClockViewController(self) }
    func makeClockViewModel() -> ClockViewModel {
        ClockViewModel(event: event, size: clockSize, type: type)
    }
}
