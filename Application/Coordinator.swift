//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import IosUseCases
import Domain
import UIKit

class Coordinator: NSObject, Coordinating {
    // MARK: - Properties
    weak var applicationFactory: ApplicationFactory?
    var detailsFactory: EventDetailsFactoring?

    let navController: UINavigationController
    private let listDelegates: MulticastDelegate<EventsListUseCaseDelegate>
    private let editDelegates: MulticastDelegate<EventEditUseCaseDelegate>

    // MARK: - Init
    init(navController: UINavigationController,
         eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseDelegate>,
         eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseDelegate>)
    {
        self.navController = navController
        self.listDelegates = eventsListMulticastDelegate
        self.editDelegates = eventEditMulticastDelegate
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(event: Event) {
        guard let detailsFactory = applicationFactory?.makeEventDetailsFactory(event: event) else { return }
        self.detailsFactory = detailsFactory

        let controller = detailsFactory.makeEventDetailsController()
        navController.pushViewController(controller, animated: true)
    }

    func showDay(event: Event, date: Date) {
        guard let dayController = detailsFactory?.makeDayController(date: date) else { return }
        presentModally(dayController)
    }

    func showGoalsInput(event: Event, callingViewModel: EventDetailsViewModel) {
        guard let goalsController = detailsFactory?.makeGoalsInputController() else { return }
        presentModally(goalsController)
    }

    func dismiss() {
        navController.dismiss(animated: true)
    }
}

// MARK: - Private
extension Coordinator {
    private func presentModally(_ controller: UIViewController) {
        if let nav = controller.navigationController { navController.present(nav, animated: true) }
    }
}

// MARK: - EventsListUseCaseDelegate & EventEditUseCaseDelegate
/// distributes domain events across all viewModels
extension Coordinator: EventsListUseCaseDelegate, EventEditUseCaseDelegate {
    // EventsListUseCaseDelegate
    func added(event: Event) { listDelegates.call { $0.added(event: event) } }
    func removed(event: Event) { listDelegates.call { $0.removed(event: event) } }
    // EventEditUseCaseDelegate
    func added(happening: Happening, to: Event) { editDelegates.call { $0.added(happening: happening, to: to) } }
    func removed(happening: Happening, from: Event) { editDelegates.call { $0.removed(happening: happening, from: from) }}
    func renamed(event: Event) { editDelegates.call { $0.renamed(event: event) } }
    func visited(event: Event) { editDelegates.call { $0.visited(event: event) }}
    func added(goal: Goal, to: Event) { editDelegates.call { $0.added(goal: goal, to: to) } }
}
