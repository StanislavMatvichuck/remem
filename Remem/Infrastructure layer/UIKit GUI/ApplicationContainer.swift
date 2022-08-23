//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import UIKit

class ApplicationContainer {
    // MARK: - Long-lived dependencies
    private var coordinator: Coordinator?
    private let eventsListUseCase: EventsListUseCaseInput
    private let eventEditUseCase: EventEditUseCaseInput
    private let eventEditMulticastDelegate = MulticastDelegate<EventEditUseCaseOutput>()
    private let eventsListMulticastDelegate = MulticastDelegate<EventsListUseCaseOutput>()

    // MARK: - Init
    init() {
        let container = CoreDataStack.createContainer(inMemory: false)
        let mapper = EventEntityMapper()
        let eventsRepository = CoreDataEventsRepository(container: container, mapper: mapper)

        self.eventsListUseCase = EventsListUseCase(repository: eventsRepository)
        self.eventEditUseCase = EventEditUseCase(repository: eventsRepository)
    }
}

// MARK: - Controllers factories
extension ApplicationContainer {
    func makeCoordinator() -> Coordinator {
        let nav = UINavigationController()

        let makeEventsListController = {
            self.makeEventsListController()
        }

        let makeDetailsController = { event in
            self.makeDetailsController(event: event)
        }

        let makeDayController = { day, event in
            self.makeDayController(day: day, event: event)
        }

        let makeGoalsInputController = { event, view in
            self.makeGoalsInputController(event: event, sourceView: view)
        }

        let coordinator = Coordinator(navController: nav,
                                      eventsListFactory: makeEventsListController,
                                      eventDetailsFactory: makeDetailsController,
                                      dayFactory: makeDayController,
                                      goalsFactory: makeGoalsInputController,
                                      eventsListMulticastDelegate: eventsListMulticastDelegate,
                                      eventEditMulticastDelegate: eventEditMulticastDelegate)
        self.coordinator = coordinator
        coordinator.start()
        return coordinator
    }

    private func makeEventsListController() -> EventsListController {
        let controller = EventsListController(eventsListUseCase: eventsListUseCase,
                                              eventEditUseCase: eventEditUseCase)
        controller.coordinator = coordinator

        eventsListMulticastDelegate.addDelegate(controller)
        eventEditMulticastDelegate.addDelegate(controller)

        return controller
    }

    private func makeDetailsController(event: Event) -> EventDetailsController {
        let weekController = WeekController()
        weekController.event = event
        weekController.coordinator = coordinator
        eventEditMulticastDelegate.addDelegate(weekController)

        let clockController = ClockController()
        clockController.event = event

        let details = EventDetailsController(event: event,
                                             editUseCase: eventEditUseCase,
                                             clockController: clockController,
                                             weekController: weekController)
        details.coordinator = coordinator
        return details
    }

    private func makeDayController(day: DateComponents, event: Event) -> DayController {
        let controller = DayController(event: event, day: day, editUseCase: eventEditUseCase)
        eventEditMulticastDelegate.addDelegate(controller)

        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController { sheet.detents = [.medium(), .large()] }

        return controller
    }

    private func makeGoalsInputController(event: Event, sourceView: UIView) -> GoalsInputController {
        let goalsInputController = GoalsInputController(event, editUseCase: eventEditUseCase)
        let nav = UINavigationController(rootViewController: goalsInputController)

        nav.preferredContentSize = CGSize(width: .wScreen, height: 250)
        nav.modalPresentationStyle = .popover

        if let pc = nav.presentationController { pc.delegate = coordinator }
        if let pop = nav.popoverPresentationController {
            pop.sourceView = sourceView
            pop.sourceRect = CGRect(x: sourceView.bounds.minX,
                                    y: sourceView.bounds.minY,
                                    width: sourceView.bounds.width,
                                    height: sourceView.bounds.height - UIHelper.font.pointSize)
        }

        return goalsInputController
    }
}
