//
//  WeekContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class WeekContainer:
    ControllerFactoring,
    WeekViewModelFactoring,
    WeekItemViewModelFactoring
{
    let parent: EventDetailsContainer
    let commander: UpdatingCommander

    var event: Event { parent.event }
    var today: DayIndex { parent.today }
    var coordinator: Coordinator { parent.parent.parent.coordinator }

    init(parent: EventDetailsContainer) {
        self.parent = parent
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let controller = WeekViewController(self)
        commander.delegate = WeakRef(controller)
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        WeekViewModel(
            today: today,
            event: event,
            itemFactory: self
        )
    }

    func makeViewModel(day: DayIndex) -> WeekItemViewModel {
        WeekItemViewModel(
            event: event,
            day: day,
            today: today,
            tapHandler: {
                self.coordinator.show(Navigation.dayDetails(factory: self.makeContainer(day: day)))
            }
        )
    }

    func makeContainer(day: DayIndex) -> DayDetailsContainer {
        DayDetailsContainer(
            parent: self,
            day: day
        )
    }
}
