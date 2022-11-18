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
    let coordinator: Coordinator
    let eventsListUseCase: EventsListUseCasing
    let eventEditUseCase: EventEditUseCasing
    // MARK: - Init
    init() {
        func makeCoordinator() -> Coordinator {
            let navController = Self.makeStyledNavigationController()
            navController.navigationBar.prefersLargeTitles = true
            let coordinator = Coordinator(navController: navController)
            return coordinator
        }

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

        let coordinator = makeCoordinator()

        self.coordinator = coordinator

        coordinator.applicationFactory = self
    }

    // MARK: - Controllers creation

    func makeRootViewController() -> UIViewController {
        let eventsListFactory = EventsListFactory(applicationFactory: self)
        let eventsListController = eventsListFactory.makeEventsListController()
        coordinator.navController.pushViewController(eventsListController, animated: false)
        return coordinator.navController
    }

    func makeEventDetailsFactory(event: Event) -> EventDetailsFactoring {
        let factory = EventDetailsFactory(applicationFactory: self, event: event)
        return factory
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
