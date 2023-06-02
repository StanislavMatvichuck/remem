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
    let parent: EventDetailsContainer
    let commander: UpdatingCommander
    var event: Event { parent.event }

    init(parent: EventDetailsContainer) {
        self.parent = parent
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let controller = ClockViewController(self)
        commander.delegate = WeakRef(controller)
        return controller
    }

    func makeClockViewModel() -> ClockViewModel {
        ClockViewModel(event: event, size: 24)
    }
}
