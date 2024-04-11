//
//  EventDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class EventDetailsContainer:
    EventDetailsViewModelFactoring,
    EventDetailsControllerFactoring
{
    let parent: ApplicationContainer
    var event: Event!
    var commander: EventsCommanding { parent.commander }
    var currentMoment: Date { parent.currentMoment }

    init(_ parent: ApplicationContainer) {
        self.parent = parent
    }

    func make() -> UIViewController {
        EventDetailsViewController(
            factory: self,
            controllers: [
                WeekContainer(self).make(),
                SummaryContainer(parent: self).make(),
                GoalsContainer(self).make(),
                HourDistributionContainer(self).make(),
                DayOfWeekContainer(self).make(),
                PDFWritingContainer(self).make()
            ],
            service: VisitEventService(event: event, repository: commander)
        )
    }

    func makeEventDetailsController(event: Event) -> EventDetailsViewController {
        self.event = event
        return make() as! EventDetailsViewController
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(event: event)
    }
}
