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
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }

    init(
        _ parent: EventsListContainer,
        event: Event,
        today: DayIndex
    ) {
        self.parent = parent
        self.event = event
        self.today = today
    }

    func make() -> UIViewController {
        let clockNight = ClockContainer(parent: self, type: .night).make() as! ClockViewController
        let clockDay = ClockContainer(parent: self, type: .day).make() as! ClockViewController
        let newWeek = NewWeekContainer(self, today: today.date).make()
        let summary = SummaryContainer(parent: self).make() as! SummaryViewController
        let pdf = PdfMakingContainer(parent: self).make()

        let controller = EventDetailsViewController(
            factory: self,
            controllers: [
                newWeek,
                summary,
                clockDay,
                clockNight,
                pdf
            ]
        )

        updater.addDelegate(controller)
        return controller
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(event: event) { event in
            event.visit()
            self.commander.save(event)
        }
    }
}
