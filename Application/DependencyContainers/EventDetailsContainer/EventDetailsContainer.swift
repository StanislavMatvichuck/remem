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
        parent: EventsListContainer,
        event: Event,
        today: DayIndex
    ) {
        self.parent = parent
        self.event = event
        self.today = today
    }

    func make() -> UIViewController {
        let clock = makeClockViewController()
        let week = makeWeekViewController()
        let summary = makeSummaryViewController()
        let pdf = makePdfMakingViewController(week, summary)

        let controller = EventDetailsViewController(
            factory: self,
            controllers: [week, clock, summary, pdf]
        )

        updater.addDelegate(controller)
        return controller
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(
            event: event,
            commander: commander
        )
    }

    func makeWeekViewController() -> WeekViewController {
        WeekContainer(parent: self).make() as! WeekViewController
    }

    func makeSummaryViewController() -> SummaryViewController {
        SummaryContainer(parent: self).make() as! SummaryViewController
    }

    func makeClockViewController() -> ClockViewController {
        ClockContainer(parent: self).make() as! ClockViewController
    }

    func makePdfMakingViewController(
        _ week: WeekViewController,
        _ summary: SummaryViewController
    ) -> PdfMakingViewController {
        PdfMakingContainer(
            week: week,
            summary: summary,
            coordinator: parent.parent.coordinator
        ).make() as! PdfMakingViewController
    }
}
