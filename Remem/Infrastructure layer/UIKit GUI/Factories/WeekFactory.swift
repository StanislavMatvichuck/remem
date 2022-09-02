//
//  WeekFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.09.2022.
//

import Foundation

protocol WeekFactoryInterface: AnyObject {
    func makeWeekCellViewModel(weekDay: WeekDay) -> WeekCellViewModel
}

class WeekFactory: WeekFactoryInterface {
    // MARK: - Properties
    let eventDetailsFactory: EventDetailsFactory
    // MARK: - Init
    init(eventDetailsFactory: EventDetailsFactory) {
        self.eventDetailsFactory = eventDetailsFactory
    }

    func makeWeekController() -> WeekController {
        let view = WeekView()
        let viewModel = makeWeekViewModel()
        let controller = WeekController(viewRoot: view, viewModel: viewModel, factory: self)
        viewModel.delegate = controller
        return controller
    }

    func makeWeekViewModel() -> WeekViewModel {
        let viewModel = WeekViewModel(event: eventDetailsFactory.event)
        eventDetailsFactory.applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = eventDetailsFactory.applicationFactory.coordinator
        return viewModel
    }

    // WeekFactoryInterface
    func makeWeekCellViewModel(weekDay: WeekDay) -> WeekCellViewModel {
        let viewModel = WeekCellViewModel(weekDay: weekDay)
        eventDetailsFactory.applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = eventDetailsFactory.applicationFactory.coordinator
        return viewModel
    }
}
