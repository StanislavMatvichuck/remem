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
        let clockNight = ClockContainer(parent: self, type: .night).make() as! ClockViewController
        let clockDay = ClockContainer(parent: self, type: .day).make() as! ClockViewController
        let newWeek = NewWeekContainer(self, today: today.date).make()
        let week = makeWeekViewController()
        let summary = makeSummaryViewController()
        let pdf = makePdfMakingViewController(week, summary, clockNight)
        let visualisation = makeVisualisationMakingViewController()

        let controller = EventDetailsViewController(
            factory: self,
            controllers: [week, newWeek, summary, clockDay, clockNight, pdf, visualisation]
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

    func makeWeekViewController() -> WeekViewController {
        WeekContainer(parent: self).make() as! WeekViewController
    }

    func makeSummaryViewController() -> SummaryViewController {
        SummaryContainer(parent: self).make() as! SummaryViewController
    }

    func makePdfMakingViewController(
        _ week: WeekViewController,
        _ summary: SummaryViewController,
        _ clock: ClockViewController
    ) -> PdfMakingViewController {
        PdfMakingContainer(parent: self).make() as! PdfMakingViewController
    }

    func makeVisualisationMakingViewController() -> VisualisationMakingViewController {
        VisualisationMakingViewController(VisualisationMakingView())
    }
}
