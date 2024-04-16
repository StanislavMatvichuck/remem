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
    var event: Event { parent.provider.get().first { $0.id == eventId }! }

    init(_ parent: ApplicationContainer, eventId: String) {
        self.parent = parent
        self.eventId = eventId
    }

    func makeEventDetailsController() -> EventDetailsViewController {
        EventDetailsViewController(
            factory: self,
            controllers: [
                WeekContainer(self).makeWeekController(),
                SummaryContainer(self).makeSummaryController(),
                GoalsContainer(self).makeGoalsController(),
                HourDistributionContainer(self).makeHourDistributionController(),
                DayOfWeekContainer(self).makeDayOfWeekController(),
                PDFWritingContainer(self).makePDFWritingController()
            ],
            service: VisitEventService(event: event, repository: parent.commander)
        )
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel { EventDetailsViewModel(event: event) }
}
