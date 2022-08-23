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
        func makeEventsRepository() -> EventsRepositoryInterface {
            let container = CoreDataStack.createContainer(inMemory: false)
            let mapper = EventEntityMapper()
            return CoreDataEventsRepository(container: container, mapper: mapper)
        }

        let repository = makeEventsRepository()
        self.eventsListUseCase = EventsListUseCase(repository: repository)
        self.eventEditUseCase = EventEditUseCase(repository: repository)
    }
}

// MARK: - Public
extension ApplicationContainer {
    func makeCoordinator() -> Coordinator {
        let rootController = makeEventsList()
        let nav = UINavigationController(rootViewController: rootController)
        let coordinator = Coordinator(navController: nav,
                                      controllersFactory: self,
                                      eventsListMulticastDelegate: eventsListMulticastDelegate,
                                      eventEditMulticastDelegate: eventEditMulticastDelegate)
        rootController.coordinator = coordinator
        self.coordinator = coordinator
        return coordinator
    }
}

// MARK: - CoordinatorFactories
extension ApplicationContainer: CoordinatorFactories {
    func makeEventDetails(for event: Event) -> EventDetailsController {
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

    func makeDay(at day: DateComponents, for event: Event) -> DayController {
        let controller = DayController(event: event, day: day, editUseCase: eventEditUseCase)
        eventEditMulticastDelegate.addDelegate(controller)

        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController { sheet.detents = [.medium(), .large()] }

        return controller
    }

    func makeGoalsInput(for event: Event, sourceView: UIView) -> GoalsInputController {
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

// MARK: - Private
extension ApplicationContainer {
    private func makeEventsList() -> EventsListController {
        let controller = EventsListController(eventsListUseCase: eventsListUseCase,
                                              eventEditUseCase: eventEditUseCase)

        eventsListMulticastDelegate.addDelegate(controller)
        eventEditMulticastDelegate.addDelegate(controller)

        return controller
    }
}
