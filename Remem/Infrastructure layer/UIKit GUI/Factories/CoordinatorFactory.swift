//
//  CoordinatorContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.08.2022.
//

import UIKit

class CoordinatorFactory: CoordinatorFactoryInterface {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    var eventsListUseCase: EventsListUseCase { applicationFactory.eventsListUseCase }
    var eventEditUseCase: EventEditUseCase { applicationFactory.eventEditUseCase }
    var eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput> { applicationFactory.eventsListMulticastDelegate }
    var eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput> { applicationFactory.eventEditMulticastDelegate }
    // MARK: - Init
    init(applicationFactory: ApplicationFactory) {
        self.applicationFactory = applicationFactory
    }

    func makeCoordinator() -> Coordinator {
        let navController = makeStyledNavigationController()
        let coordinator = Coordinator(navController: navController,
                                      coordinatorFactory: self,
                                      eventsListMulticastDelegate: eventsListMulticastDelegate,
                                      eventEditMulticastDelegate: eventEditMulticastDelegate)
        eventsListUseCase.delegate = coordinator
        eventEditUseCase.delegate = coordinator

        let eventsListFactory = EventsListFactory(coordinatorFactory: self, coordinator: coordinator)
        let eventsListController = eventsListFactory.makeEventsListController()

        coordinator.navController.pushViewController(eventsListController, animated: false)

        return coordinator
    }

    func makeWeekController(for event: Event) -> WeekController {
        let weekController = WeekController()
        weekController.event = event
        eventEditMulticastDelegate.addDelegate(weekController)
        return weekController
    }

    func makeClockController(for event: Event) -> ClockController {
        let clockController = ClockController()
        clockController.event = event
        return clockController
    }

    func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    func makeNavigationBarAppearance() -> UINavigationBarAppearance {
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
        return appearance
    }

    func makeEventDetailsController(for event: Event) -> EventDetailsController {
        let week = makeWeekController(for: event)
        let clock = makeClockController(for: event)
        let details = EventDetailsController(event: event,
                                             editUseCase: eventEditUseCase,
                                             clockController: clock,
                                             weekController: week)
        return details
    }

    func makeDayController(at day: DateComponents, for event: Event) -> DayController {
        let day: DayController = {
            let dayController = DayController(event: event, day: day, editUseCase: eventEditUseCase)
            eventEditMulticastDelegate.addDelegate(dayController)
            return dayController
        }()

        let nav = makeStyledNavigationController()
        nav.pushViewController(day, animated: false)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        return day
    }

    func makeGoalsInputController(for event: Event, sourceView: UIView) -> GoalsInputController {
        let goalsInputController = GoalsInputController(event, editUseCase: eventEditUseCase)
        let nav = makeStyledNavigationController()
        nav.pushViewController(goalsInputController, animated: false)
        nav.preferredContentSize = CGSize(width: .wScreen, height: 250)
        nav.modalPresentationStyle = .popover

        if let pc = nav.presentationController { pc.delegate = goalsInputController }
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
