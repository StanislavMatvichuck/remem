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
    let factory: ApplicationFactory
    let goalEditUseCase: GoalEditUseCasing

    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event) {
        self.factory = applicationFactory
        self.event = event
        self.goalEditUseCase = GoalEditUseCase(event: event, eventEditUseCase: applicationFactory.eventEditUseCase)
    }

    func makeEventDetailsController() -> EventDetailsController {
        let clockController = makeClockController()
        let weekController = makeWeekController()
        let controller = EventDetailsController(
            event: event,
            useCase: factory.eventEditUseCase,
            coordinator: factory.coordinator!,
            controllers: [weekController]
        )
        return controller
    }

    func makeClockController() -> ClockController {
        let factory = ClockFactory(applicationFactory: factory, event: event)
        return factory.makeClockController()
    }

    func makeWeekController() -> WeekController {
        let factory = WeekFactory(applicationFactory: factory, event: event, goalEditUseCase: goalEditUseCase)
        let controller = factory.makeWeekController(event: event)
        return controller
    }

    func makeDayController(date: Date) -> DayController {
        let factory = DayFactory(applicationFactory: factory, date: date, event: event)
        let controller = factory.makeDayController()
        return controller
    }

    func makeGoalsInputController() -> GoalsInputController {
        let factory = GoalsInputFactory(applicationFactory: factory,
                                        goalEditUseCase: goalEditUseCase,
                                        sourceView: nil,
                                        event: event)
        let controller = factory.makeGoalsInputController()
        return controller
    }
}
