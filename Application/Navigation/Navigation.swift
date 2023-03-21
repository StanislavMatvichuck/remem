//
//  Navigation.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import UIKit

protocol ControllerFactoring {
    func make() -> UIViewController
}

enum Navigation {
    case eventsList(factory: ControllerFactoring)
    case eventDetails(factory: ControllerFactoring)
    case dayDetails(factory: ControllerFactoring)
    case pdf(factory: ControllerFactoring)

    func show(in navigationController: UINavigationController) {
        switch self {
        case .eventsList:
            navigationController.pushViewController(controller, animated: false)
        case .eventDetails:
            navigationController.pushViewController(controller, animated: true)
        case .dayDetails:
            // someone has to provide animator to whom?
            let nav = Coordinator.makeStyledNavigationController()
            nav.pushViewController(controller, animated: false)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
            }

            navigationController.present(nav, animated: true)
        case .pdf:
            navigationController.pushViewController(controller, animated: true)
        }
    }

    private static let dayDetailsAnimator = DayDetailsAnimator()

    var controller: UIViewController {
        switch self {
        case .eventsList(let factory): return factory.make()
        case .eventDetails(let factory): return factory.make()
        case .dayDetails(let factory): return factory.make()
        case .pdf(let factory): return factory.make()
        }
    }
}
