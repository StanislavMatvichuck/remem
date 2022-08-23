//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

class Coordinator: NSObject {
    typealias EventsListFactory = () -> UIViewController
    typealias EventDetailsFactory = (_ event: Event) -> EventDetailsController
    typealias DayFactory = (_ day: DateComponents, _ event: Event) -> DayController
    typealias GoalsFactory = (_ event: Event, _ sourceView: UIView) -> GoalsInputController
    typealias EventsListDelegate = MulticastDelegate<EventsListUseCaseOutput>
    typealias EventEditDelegate = MulticastDelegate<EventEditUseCaseOutput>

    let navController: UINavigationController
    let makeEventsListController: EventsListFactory
    let makeDetailsController: EventDetailsFactory
    let makeDayController: DayFactory
    let makeGoalsInputController: GoalsFactory
    let eventsListMulticastDelegate: EventsListDelegate
    let eventEditMulticastDelegate: EventEditDelegate

    init(navController: UINavigationController,
         eventsListFactory: @escaping EventsListFactory,
         eventDetailsFactory: @escaping EventDetailsFactory,
         dayFactory: @escaping DayFactory,
         goalsFactory: @escaping GoalsFactory,
         eventsListMulticastDelegate: EventsListDelegate,
         eventEditMulticastDelegate: EventEditDelegate)
    {
        self.navController = navController
        self.makeEventsListController = eventsListFactory
        self.makeDetailsController = eventDetailsFactory
        self.makeDayController = dayFactory
        self.makeGoalsInputController = goalsFactory

        self.eventsListMulticastDelegate = eventsListMulticastDelegate
        self.eventEditMulticastDelegate = eventEditMulticastDelegate
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func start() { // is it needed at all?
        configureNavigationControllerStyle()
        let controller = makeEventsListController()
        navController.pushViewController(controller, animated: false)
    }

    func showDetails(for event: Event) {
        let details = makeDetailsController(event)
        navController.pushViewController(details, animated: true)
    }

    func showDayController(for day: DateComponents, event: Event) {
        let dayController = makeDayController(day, event)
        guard let nav = dayController.navigationController else { return }
        configureAppearance(for: nav)
        navController.present(nav, animated: true, completion: nil)
    }

    func showGoalsInputController(event: Event, sourceView: UIView) {
        let goalsController = makeGoalsInputController(event, sourceView)
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
