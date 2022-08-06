//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

class Coordinator {
    private let navController: UINavigationController
    private var eventsList: EventsListController!

    init(_ navController: UINavigationController) {
        self.navController = navController
    }
}

// MARK: - Public
extension Coordinator {
    func start() {
        configureNavigationControllerStyle()

        let controller = makeStartController()
        navController.pushViewController(controller, animated: false)
    }

    func showDetails(for event: Event) {
        let details = makeDetailsController(for: event)
        navController.pushViewController(details, animated: true)
    }

    func showDayController(for day: DateComponents, event: Event) {
        let day = makeDayController(day, event)

        let nav = UINavigationController(rootViewController: day)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        navController.present(nav, animated: true, completion: nil)
    }
}

// MARK: - Private
extension Coordinator {
    private func makeStartController() -> UIViewController {
        let eventsRepository = CoreDataEventsRepository()
        let eventsListUseCase = EventsListUseCase(repository: eventsRepository)
        let eventEditUseCase = EventEditUseCase(repository: eventsRepository)

        let controller = EventsListController(eventsListUseCase: eventsListUseCase,
                                              eventEditUseCase: eventEditUseCase)
        controller.coordinator = self
        eventsListUseCase.delegate = controller
        eventEditUseCase.delegate = controller
        eventsList = controller

        return controller
    }

    private func configureNavigationControllerStyle() {
        navController.navigationBar.prefersLargeTitles = true

        navController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIHelper.itemFont,
            NSAttributedString.Key.font: UIHelper.fontBold,
        ]

        navController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIHelper.itemFont,
            NSAttributedString.Key.font: UIHelper.fontSmallBold,
        ]
    }

    private func presentSettings() {
        let controller = SettingsController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        navController.present(nav, animated: true, completion: nil)
    }

    private func makeDetailsController(for event: Event) -> EventDetailsController {
        let eventsRepository = CoreDataEventsRepository()
        let editUseCase = EventEditUseCase(repository: eventsRepository)
        editUseCase.delegate = eventsList

        let weekController = WeekController()
        weekController.event = event
        weekController.coordinator = self

        let clockController = ClockController()
        clockController.event = event

        let details = EventDetailsController(event: event,
                                             editUseCase: editUseCase,
                                             clockController: clockController,
                                             weekController: weekController)

        return details
    }

    private func makeDayController(_ day: DateComponents, _ event: Event) -> DayController {
        let controller = DayController()
        controller.day = day
        controller.event = event
        return controller
    }
}
