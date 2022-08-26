//
//  CoordinatorContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.08.2022.
//

import UIKit

class CoordinatorContainer {
    let applicationContainer: ApplicationContainer
    lazy var coordinator = makeCoordinator()

    var eventsListUseCase: EventsListUseCase { applicationContainer.eventsListUseCase }
    var eventEditUseCase: EventEditUseCase { applicationContainer.eventEditUseCase }
    var eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput> { applicationContainer.eventsListMulticastDelegate }
    var eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput> { applicationContainer.eventEditMulticastDelegate }

    init(applicationContainer: ApplicationContainer) {
        self.applicationContainer = applicationContainer
    }

    func makeCoordinator() -> Coordinator {
        let rootController = makeEventsList()
        let nav = makeStyledNavigationController(for: rootController)
        nav.navigationBar.prefersLargeTitles = true

        let coordinator = Coordinator(navController: nav,
                                      coordinatorFactory: self,
                                      eventsListMulticastDelegate: eventsListMulticastDelegate,
                                      eventEditMulticastDelegate: eventEditMulticastDelegate)
        rootController.coordinator = coordinator
        eventsListUseCase.delegate = coordinator
        eventEditUseCase.delegate = coordinator
        return coordinator
    }

    func makeEventsList() -> EventsListController {
        let events = eventsListUseCase.allEvents()
        let viewModel = EventsListViewModel(events: events)
        let view = EventsListView(viewModel: viewModel)
        let controller = EventsListController(view: view,
                                              viewModel: viewModel,
                                              listUseCase: eventsListUseCase,
                                              editUseCase: eventEditUseCase)
        eventsListMulticastDelegate.addDelegate(controller)
        eventEditMulticastDelegate.addDelegate(controller)
        viewModel.controller = controller
        viewModel.view = view
        return controller
    }

    func makeWeekController(for event: Event) -> WeekController {
        let weekController = WeekController()
        weekController.event = event
        weekController.coordinator = coordinator
        eventEditMulticastDelegate.addDelegate(weekController)
        return weekController
    }

    func makeClockController(for event: Event) -> ClockController {
        let clockController = ClockController()
        clockController.event = event
        return clockController
    }

    func makeDayController(at day: DateComponents, for event: Event) -> DayController {
        let dayController = DayController(event: event, day: day, editUseCase: eventEditUseCase)
        eventEditMulticastDelegate.addDelegate(dayController)
        return dayController
    }

    func makeStyledNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController(rootViewController: rootViewController)
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
}

// MARK: - CoordinatorFactories
extension CoordinatorContainer: CoordinatorFactory {
    func makeEventDetails(for event: Event) -> EventDetailsController {
        let week = makeWeekController(for: event)
        let clock = makeClockController(for: event)
        let details = EventDetailsController(event: event,
                                             editUseCase: eventEditUseCase,
                                             clockController: clock,
                                             weekController: week)
        details.coordinator = coordinator
        return details
    }

    func makeDay(at day: DateComponents, for event: Event) -> DayController {
        let day = makeDayController(at: day, for: event)
        let nav = makeStyledNavigationController(for: day)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        return day
    }

    func makeGoalsInput(for event: Event, sourceView: UIView) -> GoalsInputController {
        let goalsInputController = GoalsInputController(event, editUseCase: eventEditUseCase)
        let nav = makeStyledNavigationController(for: goalsInputController)

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
