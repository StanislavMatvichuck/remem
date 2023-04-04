//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class DayDetailsContainer:
    ControllerFactoring,
    DayDetailsViewModelFactoring,
    DayItemViewModelFactoring
{
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var event: Event { parent.event }

    let parent: WeekContainer
    let day: DayIndex

    init(
        parent: WeekContainer,
        day: DayIndex
    ) {
        self.parent = parent
        self.day = day
    }

    func make() -> UIViewController {
        let controller = DayDetailsViewController(self)
        updater.addDelegate(controller)
        return controller
    }

    func makeViewModel(happening: Happening) -> DayItemViewModel {
        DayItemViewModel(
            event: event,
            happening: happening,
            commander: commander
        )
    }

    func makeDayViewModel() -> DayDetailsViewModel {
        DayDetailsViewModel(
            day: day,
            event: event,
            isToday: day == parent.today,
            hour: calendar.component(.hour, from: .now),
            minute: calendar.component(.minute, from: .now),
            commander: commander,
            itemFactory: self
        )
    }
}
