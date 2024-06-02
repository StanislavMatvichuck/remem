//
//  EventsOrderingService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.03.2024.
//

import Domain
import Foundation
import UIKit

protocol EventsOrderingControllerFactoring {
    func makeEventsOrderingController(using: ShowEventsOrderingServiceArgument) -> EventsSortingController
}

struct ShowEventsOrderingServiceArgument {
    let offset: CGFloat
    let oldValue: EventsList.Ordering?
}

struct ShowEventsOrderingService: ApplicationService {
    private let coordinator: Coordinator
    private let factory: EventsOrderingControllerFactoring

    init(coordinator: Coordinator, factory: EventsOrderingControllerFactoring) {
        self.coordinator = coordinator
        self.factory = factory
    }

    func serve(_ argument: ShowEventsOrderingServiceArgument) {
        let controller = factory.makeEventsOrderingController(using: argument)
        coordinator.goto(navigation: .eventsOrdering, controller: controller)
    }
}
