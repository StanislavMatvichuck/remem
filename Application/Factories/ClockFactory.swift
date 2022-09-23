//
//  ClockFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.09.2022.
//

import Foundation
import IosUseCases
import Domain

class ClockFactory {
    // MARK: - Properties
    private let applicationFactory: ApplicationFactory
    private let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event) {
        self.applicationFactory = applicationFactory
        self.event = event
    }

    func makeClockController() -> ClockController {
        let view = makeClockView()
        let viewModel = makeClockViewModel()
        let controller = ClockController(viewRoot: view, viewModel: viewModel)
        viewModel.delegate = controller
        return controller
    }

    private func makeClockViewModel() -> ClockViewModel {
        let viewModel = ClockViewModel(event: event)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        return viewModel
    }

    private func makeClockView() -> ClockView {
        ClockView()
    }
}
