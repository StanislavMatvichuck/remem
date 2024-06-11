//
//  EventCreationContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import Domain
import UIKit

final class EventCreationContainer:
    EventCreationViewModelFactoring,
    CreateEventControllerFactoring
{
    private let parent: ApplicationContainer

    init(parent: ApplicationContainer) { self.parent = parent }

    func makeEventCreationViewModel() -> EventCreationViewModel { EventCreationViewModel() }
    func makeCreateEventController() -> EventCreationController { EventCreationController(self, submitService: makeCreateEventService()) }
    func makeCreateEventService() -> CreateEventService { CreateEventService(eventsStorage: parent.eventsWriter) }
}
