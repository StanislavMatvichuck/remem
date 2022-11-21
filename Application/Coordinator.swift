//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Domain
import IosUseCases
import UIKit

class Coordinator: NSObject, Coordinating {
    // MARK: - Properties
    let factory: ApplicationFactory
    let navController: UINavigationController

    // MARK: - Init
    init(
        navController: UINavigationController,
        applicationFactory: ApplicationFactory
    ) {
        self.navController = navController
        self.factory = applicationFactory
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(event: Event) {
        navController.pushViewController(
            factory.makeEventDetailsController(event: event),
            animated: true
        )
    }

    func showDay(event: Event, date: Date) {
        presentModally(factory.makeDayController(event: event, date: date))
    }

    func showGoalsInput(event: Event) {
        presentModally(factory.makeGoalsInputController(event: event))
    }

    func dismiss() {
        navController.dismiss(animated: true)
    }
}

// MARK: - Private
extension Coordinator {
    private func presentModally(_ controller: UIViewController) {
        if let nav = controller.navigationController { navController.present(nav, animated: true) }
    }
}
