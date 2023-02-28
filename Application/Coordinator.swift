//
//  Coordinator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

import UIKit

protocol ControllerFactoring {
    func make() -> UIViewController
}

enum Navigation {
    case eventsList(factory: ControllerFactoring)
    case eventDetails(factory: ControllerFactoring)
    case dayDetails(factory: ControllerFactoring)

    func show(in navigationController: UINavigationController) {
        switch self {
        case .eventsList:
            navigationController.pushViewController(controller, animated: false)
        case .eventDetails:
            navigationController.pushViewController(controller, animated: true)
        case .dayDetails:
            let nav = Coordinator.makeStyledNavigationController()
            nav.pushViewController(controller, animated: false)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }

            navigationController.present(nav, animated: true)
        }
    }

    var controller: UIViewController {
        switch self {
        case .eventsList(let factory): return factory.make()
        case .eventDetails(let factory): return factory.make()
        case .dayDetails(let factory): return factory.make()
        }
    }
}

class Coordinator {
    let navigationController: UINavigationController

    init() {
        navigationController = Self.makeStyledNavigationController()
    }

    func show(_ navigation: Navigation) {
        navigation.show(in: navigationController)
    }

    // MARK: - UINavigationController styling
    static func makeStyledNavigationController() -> UINavigationController {
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
