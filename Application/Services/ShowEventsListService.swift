//
//  ShowEventsListService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2024.
//

import Domain
import Foundation

protocol EventsListControllerFactoring {
    func makeEventsListController() -> EventsListController
}

struct ShowEventsListService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: EventsListControllerFactoring
    private let eventsProvider: EventsQuerying

    init(
        coordinator: Coordinator,
        factory: EventsListControllerFactoring,
        eventsProvider: EventsQuerying
    ) {
        self.coordinator = coordinator
        self.factory = factory
        self.eventsProvider = eventsProvider
    }

    func serve(_: ApplicationServiceEmptyArgument) {
        coordinator.goto(
            navigation: .eventsList,
            controller: factory.makeEventsListController()
        )
    }
}
