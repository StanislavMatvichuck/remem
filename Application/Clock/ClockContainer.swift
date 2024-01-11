//
//  ClockContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class ClockContainer:
    ControllerFactoring,
    ClockViewModelFactoring
{
    let clockSize = 64
    let parent: EventDetailsContainer
    let type: ClockViewModel.ClockType

    var event: Event { parent.event }
    var updater: ViewControllersUpdater { parent.updater }

    init(parent: EventDetailsContainer, type: ClockViewModel.ClockType) {
        self.parent = parent
        self.type = type
    }

    func make() -> UIViewController {
        let controller = ClockViewController(self)
        updater.addDelegate(WeakRef(controller))
        return controller
    }

    func makeClockViewModel() -> ClockViewModel {
        ClockViewModel(event: event, size: clockSize, type: type)
    }
}
