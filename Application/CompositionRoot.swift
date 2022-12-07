//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import DataLayer
import Domain
import IosUseCases
import UIKit

class CompositionRoot: CoordinatingFactory {
    let eventsListUseCase: EventsListUseCasing
    let eventEditUseCase: EventEditUseCasing

    init(
        listUseCasing: EventsListUseCasing? = nil,
        eventEditUseCasing: EventEditUseCasing? = nil
    ) {
        let repository = Self.makeEventsRepository()
        let widgetsUseCase = WidgetsUseCase(repository: repository)
        let coreDataEventsListUseCase = EventsListUseCase(repository: repository, widgetUseCase: widgetsUseCase)
        let coreDataEventEditUseCase = EventEditUseCase(repository: repository, widgetUseCase: widgetsUseCase)

        self.eventsListUseCase = coreDataEventsListUseCase
        self.eventEditUseCase = coreDataEventEditUseCase
    }

    static func makeEventsRepository() -> EventsRepositoryInterface {
        let container = CoreDataStack.createContainer(inMemory: false)
        let mapper = EventEntityMapper()
        return CoreDataEventsRepository(container: container, mapper: mapper)
    }

    // MARK: - Controllers creation

    func makeCoordinator() -> Coordinator {
        let navController = Self.makeStyledNavigationController()
        navController.navigationBar.prefersLargeTitles = true
        let coordinator = Coordinator(
            navController: navController,
            applicationFactory: self
        )
        return coordinator
    }

    func makeRootViewController(coordinator: Coordinator) -> UIViewController {
        let eventsListController = EventsListViewController(
            listUseCase: eventsListUseCase,
            editUseCase: eventEditUseCase,
            coordinator: coordinator
        )
        coordinator.navController.pushViewController(eventsListController, animated: false)
        return coordinator.navController
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
                    event: event, coordinator: coordinator
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
        let controller = DayViewController(
            day: day,
            event: event,
            useCase: eventEditUseCase
        )

        let nav = Self.makeStyledNavigationController()
        nav.pushViewController(controller, animated: false)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        return controller
    }

    // MARK: - UINavigationController styling

    static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
        let cancelAppearance = UIBarButtonItemAppearance(style: .plain)
        cancelAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.font]

        let doneAppearance = UIBarButtonItemAppearance(style: .done)
        doneAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold,
                                          NSAttributedString.Key.foregroundColor: UIHelper.itemFont]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIHelper.itemFont,
                                               NSAttributedString.Key.font: UIHelper.fontBold]

        appearance.backButtonAppearance = cancelAppearance
        appearance.doneButtonAppearance = doneAppearance
        appearance.buttonAppearance = cancelAppearance
        return appearance
    }
}
