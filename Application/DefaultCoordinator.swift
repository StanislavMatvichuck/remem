//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Domain
import UIKit

class DefaultCoordinator {
    enum NavigationState {
        case eventsList
        case eventDetails(today: DayIndex, event: Event)
        case dayDetails(day: DayIndex)
    }

    let navController: UINavigationController
    var state: NavigationState = .eventsList {
        didSet { show(state) }
    }

    var listFactory: EventsListContainerFactoring?
    var eventDetailsFactory: EventDetailsContainerFactoring?
    var dayDetailsFactory: DayDetailsContainerFactoring?

    init(
        navController: UINavigationController = DefaultCoordinator.makeStyledNavigationController()
    ) {
        self.navController = navController
    }

    func show(_ fromCase: NavigationState) {
        switch fromCase {
        case .eventsList:
            guard let listFactory else { fatalError("coordinator factory is nil") }
            let container = listFactory.makeContainer()
            let controller = container.makeController()

            navController.pushViewController(controller, animated: false)
        case .eventDetails(let today, let event):
            guard let eventDetailsFactory else { fatalError("coordinator factory is nil") }
            let container = eventDetailsFactory.makeContainer(event: event, today: today)
            let controller = container.makeController()

            navController.pushViewController(controller, animated: true)
        case .dayDetails(let day):
            guard let dayDetailsFactory else { fatalError("coordinator factory is nil") }
            let container = dayDetailsFactory.makeContainer(day: day)
            let controller = container.makeController()

            let nav = Self.makeStyledNavigationController()
            nav.pushViewController(controller, animated: false)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }

            navController.present(nav, animated: true)
        }
    }

    // MARK: - UINavigationController styling

    private static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    private static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
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
