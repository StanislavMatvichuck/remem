//
//  EventDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class EventDetailsContainer:
    ControllerFactoring,
    EventDetailsViewModelFactoring
{
    let parent: EventsListContainer
    let event: Event
    let today: DayIndex
    let commander: UpdatingCommander

    init(
        parent: EventsListContainer,
        event: Event,
        today: DayIndex
    ) {
        self.parent = parent
        self.event = event
        self.today = today
        self.commander = UpdatingCommander(commander: parent.commander)
    }

    func make() -> UIViewController {
        let weekViewController = WeekContainer(parent: self).make()
        let clockViewController = ClockContainer(parent: self).make()
        let summaryViewController = SummaryContainer(parent: self).make()

        let controller = EventDetailsViewController(
            factory: self,
            controllers: [
                weekViewController,
                clockViewController,
                summaryViewController
            ]
        )
        commander.delegate = WeakRef(controller)
        return controller
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(
            event: event,
            commander: commander
        )
    }
}
