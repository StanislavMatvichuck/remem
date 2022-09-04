//
//  ClockFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.09.2022.
//

import Foundation

class ClockFactory {
    private let eventDetailsFactory: EventDetailsFactory
    init(eventDetailsFactory: EventDetailsFactory) {
        self.eventDetailsFactory = eventDetailsFactory
    }

    func makeClockController() -> ClockController {
        let view = makeClockView()
        let viewModel = makeClockViewModel()
        let controller = ClockController(viewRoot: view, viewModel: viewModel)
        viewModel.delegate = controller
        return controller
    }

    private func makeClockViewModel() -> ClockViewModel {
        let viewModel = ClockViewModel(event: eventDetailsFactory.event)
        eventDetailsFactory.applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        return viewModel
    }

    private func makeClockView() -> ClockView {
        ClockView()
    }
}
