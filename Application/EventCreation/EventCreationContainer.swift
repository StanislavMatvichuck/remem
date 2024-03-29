//
//  EventCreationContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import Domain
import UIKit

final class EventCreationContainer:
    ControllerFactoring,
    EventCreationViewModelFactoring,
    CreateEventControllerFactoring
{
    private let parent: ApplicationContainer

    init(parent: ApplicationContainer) { self.parent = parent }

    func make() -> UIViewController { EventCreationController(self, submitService: CreateEventService(eventsStorage: parent.commander)) }

    func makeEventCreationViewModel() -> EventCreationViewModel {
        EventCreationViewModel()
    }

    func makeCreateEventController() -> EventCreationController {
        make() as! EventCreationController
    }
}
