//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

protocol CoordinatorFactoryInterface {
    func makeEventDetailsController(for event: Event) -> EventDetailsController
    func makeDayController(at day: DateComponents, for event: Event) -> DayController
    func makeGoalsInputController(for event: Event, sourceView: UIView) -> GoalsInputController
}

class Coordinator: NSObject {
    let navController: UINavigationController
    let factory: CoordinatorFactoryInterface
    let eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>
    let eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>

    init(navController: UINavigationController,
         coordinatorFactory: CoordinatorFactoryInterface,
         eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>,
         eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>)
    {
        self.navController = navController
        self.factory = coordinatorFactory
        self.eventsListMulticastDelegate = eventsListMulticastDelegate
        self.eventEditMulticastDelegate = eventEditMulticastDelegate
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(for event: Event) {
        let details = factory.makeEventDetailsController(for: event)
        navController.pushViewController(details, animated: true)
    }

    func showDayController(for day: DateComponents, event: Event) {
        let dayController = factory.makeDayController(at: day, for: event)
        presentModally(dayController)
    }

    func showGoalsInputController(event: Event, sourceView: UIView) {
        let goalsController = factory.makeGoalsInputController(for: event, sourceView: sourceView)
        presentModally(goalsController)
    }
}

// MARK: - Private
extension Coordinator {
    private func presentModally(_ controller: UIViewController) {
        if let nav = controller.navigationController {
            navController.present(nav, animated: true)
        }
    }
}

// MARK: - EventsListUseCaseOutput & EventEditUseCaseOutput
/// distributes events across all controllers
extension Coordinator: EventsListUseCaseOutput, EventEditUseCaseOutput {
    func added(event: Event) { eventsListMulticastDelegate.invokeDelegates { $0.added(event: event) } }
    func removed(event: Event) { eventsListMulticastDelegate.invokeDelegates { $0.removed(event: event) } }
    func updated(event: Event) { eventEditMulticastDelegate.invokeDelegates { $0.updated(event: event) } }
}
