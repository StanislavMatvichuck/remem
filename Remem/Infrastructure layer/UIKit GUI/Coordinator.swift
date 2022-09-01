//
//  Coordinator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import UIKit

class Coordinator: NSObject {
    weak var factory: CoordinatorFactoryInterface?
    let navController: UINavigationController
    let listDelegates: MulticastDelegate<EventsListUseCaseOutput>
    let editDelegates: MulticastDelegate<EventEditUseCaseOutput>

    init(navController: UINavigationController,
         eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput>,
         eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput>)
    {
        self.navController = navController
        self.listDelegates = eventsListMulticastDelegate
        self.editDelegates = eventEditMulticastDelegate
        super.init()
    }
}

// MARK: - Public
extension Coordinator {
    func showDetails(for event: Event) {
        guard let details = factory?.makeEventDetailsController(for: event) else { return }
        navController.pushViewController(details, animated: true)
    }

    func showDayController(for day: DateComponents, event: Event) {
        guard let dayController = factory?.makeDayController(at: day, for: event) else { return }
        presentModally(dayController)
    }

    func showGoalsInputController(event: Event, callingViewModel: EventDetailsViewModel) {
        guard
            let callingController = callingViewModel.delegate as? EventDetailsController,
            let goalsController = factory?.makeGoalsInputController(for: event, sourceView: callingController.goalsInputView)
        else { return }
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
    // EventsListUseCaseOutput
    func added(event: Event) { listDelegates.call { $0.added(event: event) } }
    func removed(event: Event) { listDelegates.call { $0.removed(event: event) } }
    // EventEditUseCaseOutput
    func added(happening: Happening, to: Event) { editDelegates.call { $0.added(happening: happening, to: to) } }
    func removed(happening: Happening, from: Event) { editDelegates.call { $0.removed(happening: happening, from: from) }}
    func renamed(event: Event) { editDelegates.call { $0.renamed(event: event) } }
    func visited(event: Event) { editDelegates.call { $0.visited(event: event) }}
    func added(goal: Goal, to: Event) { editDelegates.call { $0.added(goal: goal, to: to) } }
}
