//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Domain
import IosUseCases
import UIKit

protocol Coordinating: AnyObject {
    func showDetails(event: Event)
    func showDay(event: Event, day: DayComponents)
}

protocol CoordinatingFactory {
    func makeEventDetailsController(event: Event, coordinator: Coordinating) -> EventViewController
    func makeDayController(day: DayComponents, event: Event) -> DayViewController
}

class Coordinator: NSObject, Coordinating {
    let factory: CoordinatingFactory
    let navController: UINavigationController

    init(
        navController: UINavigationController,
        applicationFactory: CoordinatingFactory
    ) {
        self.navController = navController
        self.factory = applicationFactory
        super.init()
    }

    // MARK: - Coordinating
    func showDetails(event: Event) {
        navController.pushViewController(
            factory.makeEventDetailsController(event: event, coordinator: self),
            animated: true
        )
    }

    func showDay(event: Event, day: DayComponents) {
        presentModally(factory.makeDayController(day: day, event: event))
    }

    private func presentModally(_ controller: UIViewController) {
        if let nav = controller.navigationController { navController.present(nav, animated: true) }
    }
}
