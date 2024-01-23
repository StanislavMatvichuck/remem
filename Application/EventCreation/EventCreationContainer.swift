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
    EventCreationViewModelFactoring
{
    private let parent: ApplicationContainer

    init(parent: ApplicationContainer) { self.parent = parent }

    func make() -> UIViewController { EventCreationController(self) }

    func makeEventCreationViewModel() -> EventCreationViewModel {
        EventCreationViewModel(submitHandler: makeSubmitHandler())
    }

    func makeSubmitHandler() -> EventCreationViewModel.SubmitHandler {{ name in
        self.parent.commander.save(Event(name: name))
    }}
}
