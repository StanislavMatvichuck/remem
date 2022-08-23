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
        configureNavigationControllerStyle()
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
        guard let nav = dayController.navigationController else { return }
        configureAppearance(for: nav)
        navController.present(nav, animated: true, completion: nil)
    }

    func showGoalsInputController(event: Event, sourceView: UIView) {
        let goalsController = controllersFactory.makeGoalsInput(for: event, sourceView: sourceView)
        guard let nav = goalsController.navigationController else { return }
        configureAppearance(for: nav)
        navController.present(nav, animated: true)
    }
}

// MARK: - Private
extension Coordinator {
    private func configureAppearance(for navigationController: UINavigationController) {
        let cancelAppearance = UIBarButtonItemAppearance(style: .plain)
        cancelAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.font]

        let doneAppearance = UIBarButtonItemAppearance(style: .done)
        doneAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIHelper.fontSmallBold,
                                          NSAttributedString.Key.foregroundColor: UIHelper.itemFont]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIHelper.itemFont,
                                               NSAttributedString.Key.font: UIHelper.fontBold]

        appearance.backButtonAppearance = cancelAppearance
        appearance.doneButtonAppearance = doneAppearance
        appearance.buttonAppearance = cancelAppearance

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.compactScrollEdgeAppearance = appearance
    }

    private func configureNavigationControllerStyle() {
        navController.navigationBar.prefersLargeTitles = true
        configureAppearance(for: navController)
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

// MARK: - Popover styling
extension Coordinator: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle
    { return .none }
}
