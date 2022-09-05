//
//  EventDetailsFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.08.2022.
//

import Foundation

protocol EventDetailsFactoryInterface {}

class EventDetailsFactory: EventDetailsFactoryInterface {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event) {
        self.applicationFactory = applicationFactory
        self.event = event
    }

    func makeEventDetailsController(weekController: WeekController, clockController: ClockController) -> EventDetailsController {
        let viewModel = makeEventDetailsViewModel()
        let view = EventDetailsView(viewModel: viewModel)

        let controller = EventDetailsController(viewRoot: view,
                                                viewModel: viewModel,
                                                clockController: clockController,
                                                weekController: weekController)
        controller.title = event.name
        viewModel.delegate = controller
        return controller
    }

    func makeEventDetailsViewModel() -> EventDetailsViewModel {
        let viewModel = EventDetailsViewModel(event: event, editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }
}
