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

class ApplicationFactory {
    // MARK: - Long-lived dependencies
    let eventsListUseCase: EventsListUseCasing
    let eventEditUseCase: EventEditUseCasing
    var coordinator: Coordinator?
    // MARK: - Init
    init() {
        func makeEventsRepository() -> EventsRepositoryInterface {
            let container = CoreDataStack.createContainer(inMemory: false)
            let mapper = EventEntityMapper()
            return CoreDataEventsRepository(container: container, mapper: mapper)
        }

        let repository = makeEventsRepository()
        let widgetsUseCase = WidgetsUseCase(repository: repository)
        self.eventsListUseCase = EventsListUseCase(repository: repository,
                                                   widgetUseCase: widgetsUseCase)
        self.eventEditUseCase = EventEditUseCase(repository: repository,
                                                 widgetUseCase: widgetsUseCase)
    }

    // MARK: - Controllers creation

    func makeCoordinator() -> Coordinator {
        let navController = Self.makeStyledNavigationController()
        navController.navigationBar.prefersLargeTitles = true
        let coordinator = Coordinator(
            navController: navController,
            applicationFactory: self
        )
        self.coordinator = coordinator
        return coordinator
    }

    func makeRootViewController(coordinator: Coordinator) -> UIViewController {
        let eventsListController = EventsListController(
            viewRoot: EventsListView(),
            listUseCase: eventsListUseCase,
            editUseCase: eventEditUseCase,
            coordinator: coordinator
        )
        coordinator.navController.pushViewController(eventsListController, animated: false)
        return coordinator.navController
    }

    func makeEventDetailsController(event: Event) -> EventDetailsController {
        let factory = EventDetailsFactory(applicationFactory: self, event: event)
        let controller = factory.makeEventDetailsController()
        return controller
    }

    func makeDayController(event: Event, date: Date) -> DayController {
        let factory = DayFactory(applicationFactory: self, date: date, event: event)
        return factory.makeDayController()
    }

    func makeGoalsInputController(event: Event) -> GoalsInputController {
        let goalUC = GoalEditUseCase(event: event, eventEditUseCase: eventEditUseCase)
        let factory = GoalsInputFactory(applicationFactory: self, goalEditUseCase: goalUC, sourceView: nil, event: event)
        return factory.makeGoalsInputController()
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
