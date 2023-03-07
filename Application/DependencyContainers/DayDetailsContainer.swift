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
    let parent: WeekContainer
    let commander: UpdatingCommander
    var event: Event { parent.event }
    let day: DayIndex

    init(
        parent: WeekContainer,
        day: DayIndex
    ) {
        self.parent = parent
        self.day = day
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let controller = DayDetailsViewController(self)
        commander.delegate = controller
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
            commander: commander,
            itemFactory: self
        )
    }
}
