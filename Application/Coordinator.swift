//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Domain
import UIKit

/// `Abstraction` in view presentation layer
/// who uses this abstraction? viewControllers for now
protocol Coordinating {
    var root: UIViewController { get }
    func show(_: CoordinatingCase)
}

enum CoordinatingCase {
    case list
    case eventItem(today: DayComponents, event: Event)
    case weekItem(day: DayComponents, event: Event)
}

protocol CoordinatingFactory {
    func makeController(for: CoordinatingCase) -> UIViewController
}

class DefaultCoordinator: Coordinating {
    let navController: UINavigationController
    var root: UIViewController { navController }
    var factory: CoordinatingFactory?

    init(
        navController: UINavigationController = DefaultCoordinator.makeStyledNavigationController()
    ) {
        self.navController = navController
    }

    func show(_ fromCase: CoordinatingCase) {
        guard let factory else { fatalError("coordinator factory is nil") }
        switch fromCase {
        case .list:
            navController.pushViewController(factory.makeController(for: .list), animated: false)
        case .eventItem(let today, let event):
            navController.pushViewController(factory.makeController(for: .eventItem(today: today, event: event)), animated: true)
        case .weekItem(let day, let event):
            let controller = factory.makeController(for: .weekItem(day: day, event: event))

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
