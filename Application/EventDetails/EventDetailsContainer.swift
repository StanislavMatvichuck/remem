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
    let parent: ApplicationContainer
    let event: Event
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var currentMoment: Date { parent.currentMoment }

    init(_ parent: ApplicationContainer, event: Event) {
        self.parent = parent
        self.event = event
    }

    func make() -> UIViewController {
        let clockNight = ClockContainer(parent: self, type: .night).make() as! ClockViewController
        let clockDay = ClockContainer(parent: self, type: .day).make() as! ClockViewController
        let week = WeekContainer(self).make()
        let summary = SummaryContainer(parent: self).make() as! SummaryViewController
        let pdf = PDFWritingContainer(self).make()
        let dayOfWeek = DayOfWeekContainer(self).make()

        let controller = EventDetailsViewController(
            factory: self,
            controllers: [
                week,
                dayOfWeek,
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
