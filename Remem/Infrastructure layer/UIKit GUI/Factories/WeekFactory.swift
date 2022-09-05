//
//  WeekFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.09.2022.
//

import Foundation

protocol WeekFactoryInterface: AnyObject {
    func makeWeekCellViewModel(date: Date) -> WeekCellViewModel
}

class WeekFactory: WeekFactoryInterface {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event) {
        self.applicationFactory = applicationFactory
        self.event = event
    }

    func makeWeekController() -> WeekController {
        let view = WeekView()
        let viewModel = makeWeekViewModel()
        let controller = WeekController(viewRoot: view, viewModel: viewModel, factory: self)
        viewModel.delegate = controller
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        let viewModel = WeekViewModel(event: event, factory: self)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    // WeekFactoryInterface
    func makeWeekCellViewModel(date: Date) -> WeekCellViewModel {
        let viewModel = WeekCellViewModel(date: date, event: event)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }
}
