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
    var event: Event { parent.eventsReader.read(byId: eventId) } // TODO: improve this

    init(_ parent: ApplicationContainer, eventId: String) {
        self.parent = parent
        self.eventId = eventId
    }

    func makeEventDetailsController() -> EventDetailsController { EventDetailsController(
        factory: self,
        controllers: [
            WeekContainer(self).makeWeekController(),
            GoalsPresenterContainer(self).makeGoalsPresenterController(),
            WeekCircleContainer(self).makeWeekCircleController(),
            HoursCircleContainer(self).makeHoursCircleController(),
            SummaryContainer(self).makeSummaryController(),
            PDFWritingContainer(self).makePDFWritingController()
        ],
        service: makeVisitEventService()
    ) }

    func makeEventDetailsViewModel() -> EventDetailsViewModel { EventDetailsViewModel(event: event) }
    func makeVisitEventService() -> VisitEventService { VisitEventService(event: event, repository: parent.eventsWriter) }
}
