//
//  EventDetailsFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.08.2022.
//

import Domain
import IosUseCases
import UIKit

protocol EventDetailsFactoring: AnyObject {
    func makeEventDetailsController() -> EventDetailsController
    func makeDayController(date: Date) -> DayController
    func makeGoalsInputController() -> GoalsInputController
}

class EventDetailsFactory: EventDetailsFactoring {
    // MARK: - Properties
    let event: Event
    let applicationFactory: ApplicationFactory
    let goalEditUseCase: GoalEditUseCasing
    var goalInputSourceView: UIView?
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event) {
        self.applicationFactory = applicationFactory
        self.event = event
        self.goalEditUseCase = GoalEditUseCase(event: event, eventEditUseCase: applicationFactory.eventEditUseCase)
    }

    func makeEventDetailsController() -> EventDetailsController {
        let viewModel = makeEventDetailsViewModel()

        let viewRoot = EventDetailsView(viewModel: viewModel)
        goalInputSourceView = viewRoot.week

        let clockController = makeClockController()
        let weekController = makeWeekController()
        let controller = EventDetailsController(viewRoot: viewRoot,
                                                viewModel: viewModel,
                                                clockController: clockController,
                                                weekController: weekController)
        controller.title = event.name
        viewModel.delegate = controller
        return controller
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        let viewModel = EventDetailsViewModel(event: event, editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventEditUseCase.add(delegate: viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    func makeClockController() -> ClockController {
        let factory = ClockFactory(applicationFactory: applicationFactory, event: event)
        return factory.makeClockController()
    }

    func makeWeekController() -> WeekController {
        let factory = WeekFactory(applicationFactory: applicationFactory, event: event, goalEditUseCase: goalEditUseCase)
        let controller = factory.makeWeekController()
        return controller
    }

    func makeDayController(date: Date) -> DayController {
        let factory = DayFactory(applicationFactory: applicationFactory, date: date, event: event)
        let controller = factory.makeDayController()
        return controller
    }

    func makeGoalsInputController() -> GoalsInputController {
        let factory = GoalsInputFactory(applicationFactory: applicationFactory,
                                        goalEditUseCase: goalEditUseCase,
                                        sourceView: goalInputSourceView,
                                        event: event)
        let controller = factory.makeGoalsInputController()
        return controller
    }
}
