//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Domain
import UIKit

protocol CoordinatorFactoring {
    func makeController(for: DefaultCoordinator.NavigationState) -> UIViewController
}

class DefaultCoordinator {
    enum NavigationState {
        case eventsList
        case eventDetails(today: DayComponents, event: Event)
        case dayDetails(day: DayComponents, event: Event)
    }

    let navController: UINavigationController
    var factory: CoordinatorFactoring?

    init(
        navController: UINavigationController = DefaultCoordinator.makeStyledNavigationController()
    ) {
        self.navController = navController
    }

    func show(_ fromCase: NavigationState) {
        guard let factory else { fatalError("coordinator factory is nil") }
        switch fromCase {
        case .eventsList:
            navController.pushViewController(factory.makeController(for: .eventsList), animated: false)
        case .eventDetails(let today, let event):
            navController.pushViewController(factory.makeController(for: .eventDetails(today: today, event: event)), animated: true)
        case .dayDetails(let day, let event):
            let controller = factory.makeController(for: .dayDetails(day: day, event: event))

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
