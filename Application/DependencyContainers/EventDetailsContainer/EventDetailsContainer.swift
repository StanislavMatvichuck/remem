//
//  EventDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

protocol EventDetailsViewModelFactoring { func makeViewModel() -> EventDetailsViewModel }

final class EventDetailsContainer:
    ControllerFactoring,
    EventDetailsViewModelFactoring
{
    let parent: EventsListContainer

    var coordinator: Coordinator { parent.coordinator }
    var commander: EventsCommanding { parent.updater }

    let event: Event
    let today: DayIndex

    init(
        parent: EventsListContainer,
        event: Event,
        today: DayIndex
    ) {
        print("EventDetailsContainer.init")
        self.parent = parent
        self.event = event
        self.today = today
    }

    deinit { print("EventDetailsContainer.deinit") }

    func make() -> UIViewController {
        let weekViewController = WeekContainer(parent: self).make()
        let clockViewController = ClockContainer(parent: self).make()
        let summaryViewController = SummaryContainer(parent: self).make()

        return EventDetailsViewController(
            viewModel: makeViewModel(),
            controllers: [
                weekViewController,
                clockViewController,
                summaryViewController
            ]
        )
    }

    func makeViewModel() -> EventDetailsViewModel {
        EventDetailsViewModel(
            event: event,
            commander: commander
        )
    }
}
