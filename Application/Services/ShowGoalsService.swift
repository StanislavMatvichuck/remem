//
//  ShowGoalsService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import Domain
import Foundation

protocol GoalsControllerFactoring {
    func makeGoalsController() -> GoalsController
}

// struct ShowGoalsServiceArgument {    let eventId: String }
struct ShowGoalsService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: GoalsControllerFactoring

    init(
        coordinator: Coordinator,
        factory: GoalsControllerFactoring
    ) {
        self.coordinator = coordinator
        self.factory = factory
    }

    func serve(_ arg: ApplicationServiceEmptyArgument) {
        coordinator.goto(
            navigation: .goals,
            controller: factory.makeGoalsController()
        )
    }
}
