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
        let controller = EventDetailsViewController(
            factory: self,
            controllers: [
                WeekContainer(self).make(),
                HourDistributionContainer(self).make(),
                DayOfWeekContainer(self).make(),
                SummaryContainer(parent: self).make(),
                PDFWritingContainer(self).make()
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
