//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain

import UIKit

/// Plays role of `Composer`
/// # Objects composition
/// # Dependencies lifecycle management
class CompositionRoot {
    /// Singleton dependency lifecycle
    let eventsListUseCase: EventsListUseCasing
    let eventEditUseCase: EventEditUseCasing
    let coordinator: Coordinating

    init() {
        /// Scoped dependency lifecycle?
        let repository = CoreDataEventsRepository(
            container: CoreDataStack.createContainer(
                inMemory: false
            ),
            mapper: EventEntityMapper()
        )

        let coreDataEventsListUseCase = EventsListUseCase(repository: repository)
        let coreDataEventEditUseCase = EventEditUseCase(repository: repository)

        self.eventsListUseCase = coreDataEventsListUseCase
        self.eventEditUseCase = coreDataEventEditUseCase
        self.coordinator = DefaultCoordinator()
    }

    // MARK: - Controllers creation

    func makeRootViewController() -> UIViewController {
        let eventsListController = EventsListViewController(
            listUseCase: eventsListUseCase,
            editUseCase: eventEditUseCase,
            coordinator: coordinator
        )
        coordinator.show(eventsListController)
        return eventsListController.navigationController!
    }

    func makeEventDetailsController(
        event: Event,
        coordinator: Coordinating
    ) -> EventViewController {
        EventViewController(
            event: event,
            useCase: eventEditUseCase,
            controllers: [
                makeWeekController(
                    event: event,
                    coordinator: coordinator
                ),
                makeClockViewController(event: event),
            ]
        )
    }

    func makeWeekController(
        event: Event,
        coordinator: Coordinating
    ) -> WeekViewController {
        WeekViewController(
            today: DayComponents(date: .now),
            event: event,
            useCase: eventEditUseCase,
            coordinator: coordinator
        )
    }

    func makeClockViewController(event: Event) -> ClockViewController {
        ClockViewController(
            event: event,
            useCase: eventEditUseCase,
            sorter: DefaultClockSorter(size: 144)
        )
    }

    func makeDayController(day: DayComponents, event: Event) -> DayViewController {
        DayViewController(
            day: day,
            event: event,
            useCase: eventEditUseCase
        )
    }
}
