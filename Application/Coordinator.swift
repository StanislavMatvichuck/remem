//
//  Coordinator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

import UIKit

final class Coordinator {
    enum Screen {
        case eventsList,
             createEvent,
             eventsOrdering,
             eventDetails,
             goals,
             dayDetails,
             pdfReading
    }

    let navigationController = Coordinator.makeStyledNavigationController()

    func goto(navigation: Screen, controller: UIViewController) { switch navigation {
    case .eventsList: navigationController.pushViewController(controller, animated: false)
    case .createEvent: navigationController.present(controller, animated: true)
    case .eventsOrdering: navigationController.present(controller, animated: true)
    case .eventDetails: navigationController.pushViewController(controller, animated: true)
    case .goals: navigationController.pushViewController(controller, animated: true)
    case .dayDetails: navigationController.present(controller, animated: true)
    case .pdfReading: navigationController.pushViewController(controller, animated: true)
    } }

    // MARK: - UINavigationController styling
    static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor.remem_bg
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    private static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
        let textColor = UIColor.remem_bg
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.remem_secondary

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
