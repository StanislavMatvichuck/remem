//
//  SummaryContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class SummaryContainer:
    SummaryViewModelFactoring
{
    let parent: EventDetailsContainer
    var commander: ViewControllersUpdater { parent.updater }

    var event: Event { parent.event }
    var currentMoment: Date { parent.currentMoment }

    init(parent: EventDetailsContainer) {
        self.parent = parent
    }

    func make() -> UIViewController {
        let controller = SummaryViewController(self)
        commander.addDelegate(WeakRef(controller))
        return controller
    }

    func makeSummaryViewModel() -> SummaryViewModel { SummaryViewModel(event: event, createdUntil: currentMoment) }
}
