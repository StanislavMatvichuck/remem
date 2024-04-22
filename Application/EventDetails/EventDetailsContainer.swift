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
    let eventId: String
    var event: Event { parent.provider.read(byId: eventId) }

    init(_ parent: ApplicationContainer, eventId: String) {
        self.parent = parent
        self.eventId = eventId
    }

    func makeEventDetailsController() -> EventDetailsController {
        EventDetailsController(
            factory: self,
            controllers: [
                WeekContainer(self).makeWeekController(),
                GoalsContainer(self).makeGoalsController(),
                SummaryContainer(self).makeSummaryController(),
                HourDistributionContainer(self).makeHourDistributionController(),
                DayOfWeekContainer(self).makeDayOfWeekController(),
                PDFWritingContainer(self).makePDFWritingController()
            ],
            service: VisitEventService(event: event, repository: parent.eventsStorage)
        )
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel { EventDetailsViewModel(event: event) }
}
