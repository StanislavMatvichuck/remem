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
    EventDetailsViewModelFactoring,
    EventDetailsControllerFactoring
{
    let parent: ApplicationContainer
    var event: Event!
    var commander: EventsCommanding { parent.commander }
    var updater: ViewControllersUpdater { parent.updater }
    var currentMoment: Date { parent.currentMoment }

    init(_ parent: ApplicationContainer) {
        self.parent = parent
    }

    func make() -> UIViewController {
        let controller = EventDetailsViewController(
            factory: self,
            controllers: [
                WeekContainer(self).make(),
                SummaryContainer(parent: self).make(),
                GoalsContainer(self).make(),
                HourDistributionContainer(self).make(),
                DayOfWeekContainer(self).make(),
                PDFWritingContainer(self).make()
            ]
        )

        updater.addDelegate(controller)
        return controller
    }

    func makeEventDetailsController(event: Event) -> EventDetailsViewController {
        self.event = event
        return make() as! EventDetailsViewController
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(event: event) { event in
            event.visit()
            self.commander.save(event)
        }
    }
}
