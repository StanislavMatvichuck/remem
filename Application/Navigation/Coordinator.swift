//
//  Coordinator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

import UIKit

final class Coordinator {
    let navigationController: UINavigationController

    init() {
        navigationController = Self.makeStyledNavigationController()
    }

    func show(_ navigation: Navigation) {
        let newController = navigation.controller
        switch navigation {
        case .eventsList:
            navigationController.pushViewController(newController, animated: false)
        case .eventDetails:
            navigationController.pushViewController(newController, animated: true)
        case .dayDetails(_, let week):
//            guard
//                let eventDetailsController = navigationController.topViewController as? EventDetailsViewController, // nil during test, dependency to navigation tree
//                let weekController = eventDetailsController.children.first as? WeekViewController
//            else { return }
            // only transitioningDelegate is required
            newController.transitioningDelegate = week
//            newController.transitioningDelegate = weekController
            newController.modalPresentationStyle = .custom
            navigationController.present(newController, animated: true) // uses navigationController for presenting anyway
        case .pdf:
            navigationController.pushViewController(newController, animated: true)
        }
    }

    // MARK: - UINavigationController styling
    static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor.text_secondary
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    private static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
        let textColor = UIColor.text_secondary
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.secondary

        let cancelAppearance = UIBarButtonItemAppearance(style: .plain)

        cancelAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.font,
        ]

        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.fontSmallBold,
        ]
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIFont.fontBold,
        ]

        appearance.backButtonAppearance = cancelAppearance
        appearance.buttonAppearance = cancelAppearance

        return appearance
    }
}
