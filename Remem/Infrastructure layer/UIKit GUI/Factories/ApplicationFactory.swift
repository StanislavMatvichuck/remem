//
//  ApplicationContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.08.2022.
//

import UIKit

protocol CoordinatorFactoryInterface: AnyObject {
    func makeEventDetailsController(for event: Event) -> EventDetailsController
    func makeDayController(date: Date, event: Event) -> DayController
    func makeGoalsInputController(for event: Event, sourceView: UIView) -> GoalsInputController
}

class ApplicationFactory: CoordinatorFactoryInterface {
    // MARK: - Long-lived dependencies
    let coordinator: Coordinator
    let eventsListUseCase: EventsListUseCase
    let eventEditUseCase: EventEditUseCase
    let eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>
    let eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>

    // MARK: - Init
    init() {
        func makeCoordinator(listUseCase: EventsListUseCase,
                             editUseCase: EventEditUseCase,
                             eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>,
                             eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>) -> Coordinator
        {
            let navController = Self.makeStyledNavigationController()
            navController.navigationBar.prefersLargeTitles = true
            let coordinator = Coordinator(navController: navController,
                                          eventsListMulticastDelegate: eventsListMulticastDelegate,
                                          eventEditMulticastDelegate: eventEditMulticastDelegate)
            listUseCase.delegate = coordinator
            editUseCase.delegate = coordinator
            return coordinator
        }

        func makeEventsRepository() -> EventsRepositoryInterface {
            let container = CoreDataStack.createContainer(inMemory: false)
            let mapper = EventEntityMapper()
            return CoreDataEventsRepository(container: container, mapper: mapper)
        }

        let repository = makeEventsRepository()

        let listUseCase = EventsListUseCase(repository: repository)
        let editUseCase = EventEditUseCase(repository: repository)

        self.eventsListUseCase = listUseCase
        self.eventEditUseCase = editUseCase

        let eventsListMulticastDelegate = MulticastDelegate<EventsListUseCaseOutput>()
        let eventEditMulticastDelegate = MulticastDelegate<EventEditUseCaseOutput>()

        self.eventsListMulticastDelegate = eventsListMulticastDelegate
        self.eventEditMulticastDelegate = eventEditMulticastDelegate

        self.coordinator = makeCoordinator(listUseCase: listUseCase,
                                           editUseCase: editUseCase,
                                           eventsListMulticastDelegate: eventsListMulticastDelegate,
                                           eventEditMulticastDelegate: eventEditMulticastDelegate)
        coordinator.factory = self
    }

    // MARK: - Controllers creation

    func makeRootViewController() -> UIViewController {
        let eventsListFactory = EventsListFactory(applicationFactory: self)
        let eventsListController = eventsListFactory.makeEventsListController()
        coordinator.navController.pushViewController(eventsListController, animated: false)
        return coordinator.navController
    }

    func makeEventDetailsController(for event: Event) -> EventDetailsController {
        let eventDetailsFactory = EventDetailsFactory(applicationFactory: self, event: event)
        let controller = eventDetailsFactory.makeEventDetailsController()
        return controller
    }

    func makeDayController(date: Date, event: Event) -> DayController {
        let factory = DayFactory(applicationFactory: self, date: date, event: event)
        let controller = factory.makeDayController()
        return controller
    }

    func makeGoalsInputController(for event: Event, sourceView: UIView) -> GoalsInputController {
        let viewModel = GoalsInputViewModel(event: event, editUseCase: eventEditUseCase)
        viewModel.coordinator = coordinator

        let viewRoot = GoalsInputView(viewModel: viewModel)

        let goalsInputController = GoalsInputController(viewRoot: viewRoot, viewModel: viewModel)
        viewModel.delegate = goalsInputController

        let nav = Self.makeStyledNavigationController()
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

    // MARK: - UINavigationController styling

    static func makeStyledNavigationController() -> UINavigationController {
        let appearance = makeNavigationBarAppearance()
        let nav = UINavigationController()
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactScrollEdgeAppearance = appearance
        return nav
    }

    static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
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
