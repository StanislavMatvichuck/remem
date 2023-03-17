//
//  Coordinator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.02.2023.
//

import UIKit

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
            NSAttributedString.Key.font: UIHelper.font,
        ]

        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIHelper.fontSmallBold,
        ]
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: UIHelper.fontBold,
        ]

        appearance.backButtonAppearance = cancelAppearance
        appearance.buttonAppearance = cancelAppearance

        return appearance
    }
}
