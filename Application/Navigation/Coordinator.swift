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
            newController.transitioningDelegate = week.presenter
            newController.modalPresentationStyle = .custom
            week.present(newController, animated: true)
        case .pdf:
            navigationController.pushViewController(newController, animated: true)
        }
    }

    // MARK: - UINavigationController styling
    static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor.bg
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    private static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
        let textColor = UIColor.bg
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
