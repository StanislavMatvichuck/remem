//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

protocol CoordinatorFactories {
    func makeEventDetails(for event: Event) -> EventDetailsController
    func makeDay(at day: DateComponents, for event: Event) -> DayController
    func makeGoalsInput(for event: Event, sourceView: UIView) -> GoalsInputController
}

class Coordinator: NSObject {
    let navController: UINavigationController
    let controllersFactory: CoordinatorFactories
    let eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>
    let eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>

    init(navController: UINavigationController,
         controllersFactory: CoordinatorFactories,
         eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>,
         eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>)
    {
        self.navController = navController
        self.controllersFactory = controllersFactory
        self.eventsListMulticastDelegate = eventsListMulticastDelegate
        self.eventEditMulticastDelegate = eventEditMulticastDelegate
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(for event: Event) {
        let details = controllersFactory.makeEventDetails(for: event)
        navController.pushViewController(details, animated: true)
    }

    func showDayController(for day: DateComponents, event: Event) {
        let dayController = controllersFactory.makeDay(at: day, for: event)
        presentModally(dayController)
    }

    func showGoalsInputController(event: Event, sourceView: UIView) {
        let goalsController = controllersFactory.makeGoalsInput(for: event, sourceView: sourceView)
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
