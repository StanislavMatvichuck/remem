//
//  WeekFactory.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.09.2022.
//

import Domain
import Foundation
import IosUseCases

class WeekFactory: WeekFactoryInterface {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    let useCase: GoalEditUseCase
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory, event: Event, goalEditUseCase: GoalEditUseCase) {
        self.applicationFactory = applicationFactory
        self.useCase = goalEditUseCase
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
        let goalEditMulticastDelegate = MulticastDelegate<GoalEditUseCaseDelegate>()
        let viewModel = WeekViewModel(event: event, factory: self, multicastDelegate: goalEditMulticastDelegate)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        useCase.delegate = viewModel
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
