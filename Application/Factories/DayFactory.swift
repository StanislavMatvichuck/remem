//
//  DayFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.09.2022.
//

import Foundation
import IosUseCases
import Domain

class DayFactory {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let date: Date
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, date: Date, event: Event) {
        self.applicationFactory = applicationFactory
        self.date = date
        self.event = event
    }

    func makeDayController() -> DayController {
        let view = DayView()
        let viewModel = makeDayViewModel()
        let controller = DayController(viewRoot: view, viewModel: viewModel)
        viewModel.delegate = controller

        let nav = ApplicationFactory.makeStyledNavigationController()
        nav.pushViewController(controller, animated: false)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        return controller
    }

    func makeDayViewModel() -> DayViewModel {
        let viewModel = DayViewModel(date: date,
                                     event: event,
                                     editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        return viewModel
    }
}
