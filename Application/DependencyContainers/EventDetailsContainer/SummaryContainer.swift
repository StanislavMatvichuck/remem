//
//  SummaryContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class SummaryContainer:
    ControllerFactoring,
    SummaryViewModelFactoring
{
    let parent: EventDetailsContainer
    let commander: UpdatingCommander

    var event: Event { parent.event }
    var today: DayIndex { parent.today }

    init(parent: EventDetailsContainer) {
        self.parent = parent
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let controller = SummaryViewController(self)
        commander.delegate = controller
        return controller
    }

    func makeSummaryViewModel() -> SummaryViewModel {
        SummaryViewModel(
            event: event,
            today: today
        )
    }
}
