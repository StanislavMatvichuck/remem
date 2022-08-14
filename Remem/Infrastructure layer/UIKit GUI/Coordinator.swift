//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

class Coordinator {
    private let navController: UINavigationController

    // Domain events distribution
    private var eventEditMulticastDelegate = MulticastDelegate<EventEditUseCaseOutput>()
    private var eventsListMulticastDelegate = MulticastDelegate<EventsListUseCaseOutput>()

    private let eventsListUseCase: EventsListUseCaseInput
    private let eventEditUseCase: EventEditUseCaseInput

    init(_ navController: UINavigationController) {
        self.navController = navController

        let container = CoreDataStack.createContainer(inMemory: false)
        let mapper = EventEntityMapper()
        let eventsRepository = CoreDataEventsRepository(container: container, mapper: mapper)

        let eventsListUseCase = EventsListUseCase(repository: eventsRepository)
        let eventEditUseCase = EventEditUseCase(repository: eventsRepository)

        self.eventsListUseCase = eventsListUseCase
        self.eventEditUseCase = eventEditUseCase

        eventEditUseCase.delegate = self
        eventsListUseCase.delegate = self
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
        let controller = EventsListController(eventsListUseCase: eventsListUseCase,
                                              eventEditUseCase: eventEditUseCase)
        controller.coordinator = self

        eventsListMulticastDelegate.addDelegate(controller)
        eventEditMulticastDelegate.addDelegate(controller)

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
        let weekController = WeekController()
        weekController.event = event
        weekController.coordinator = self

        let clockController = ClockController()
        clockController.event = event

        let goalsInputController = GoalsInputController(event)

        let details = EventDetailsController(event: event,
                                             editUseCase: eventEditUseCase,
                                             clockController: clockController,
                                             weekController: weekController,
                                             goalsInputController: goalsInputController)

        eventEditMulticastDelegate.addDelegate(weekController)

        return details
    }

    private func makeDayController(_ day: DateComponents, _ event: Event) -> DayController {
        let controller = DayController(event: event, day: day, editUseCase: eventEditUseCase)

        eventEditMulticastDelegate.addDelegate(controller)

        return controller
    }
}

// MARK: - Domain events distribution
extension Coordinator: EventsListUseCaseOutput {
    func eventsListUpdated(_ newList: [Event]) {
        eventsListMulticastDelegate.invokeDelegates { delegate in
            delegate.eventsListUpdated(newList)
        }
    }
}

extension Coordinator: EventEditUseCaseOutput {
    func updated(event: Event) {
        eventEditMulticastDelegate.invokeDelegates { delegate in
            delegate.updated(event: event)
        }
    }
}
