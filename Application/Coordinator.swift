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
    weak var applicationFactory: ApplicationFactory?
    var detailsFactory: EventDetailsFactoring?
    var widgetUseCase: WidgetsUseCasing?

    let navController: UINavigationController

    // MARK: - Init
    init(navController: UINavigationController,
         widgetsUseCase: WidgetsUseCasing)
    {
        self.navController = navController
        self.widgetUseCase = widgetsUseCase
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(event: Event) {
        guard let detailsFactory = applicationFactory?.makeEventDetailsFactory(event: event) else { return }
        self.detailsFactory = detailsFactory

        let controller = detailsFactory.makeEventDetailsController()
        navController.pushViewController(controller, animated: true)
    }

    func showDay(event: Event, date: Date) {
        guard let dayController = detailsFactory?.makeDayController(date: date) else { return }
        presentModally(dayController)
    }

    func showGoalsInput(event: Event, callingViewModel: EventDetailsViewModel) {
        guard let goalsController = detailsFactory?.makeGoalsInputController() else { return }
        presentModally(goalsController)
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
