//
//  ShowDayDetailsService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2024.
//

import Domain
import Foundation

protocol DayDetailsControllerFactoring {
    func makeDayDetailsController(_: ShowDayDetailsServiceArgument) -> DayDetailsController
}

struct ShowDayDetailsServiceArgument {
    let startOfDay: Date
    let eventId: String
    let presentationAnimation: () -> Void
    let dismissAnimation: () -> Void
}

struct ShowDayDetailsService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: DayDetailsControllerFactoring
    private let eventsProvider: EventsReading

    init(
        coordinator: Coordinator,
        factory: DayDetailsControllerFactoring,
        eventsProvider: EventsReading
    ) {
        self.coordinator = coordinator
        self.factory = factory
        self.eventsProvider = eventsProvider
    }

    func serve(_ arg: ShowDayDetailsServiceArgument) {
        coordinator.goto(
            navigation: .dayDetails,
            controller: factory.makeDayDetailsController(arg)
        )
    }
}
