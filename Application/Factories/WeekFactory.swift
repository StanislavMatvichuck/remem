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
    let useCase: GoalEditUseCasing
    let event: Event
    // MARK: - Init
    init(applicationFactory: ApplicationFactory,
         event: Event,
         goalEditUseCase: GoalEditUseCasing)
    {
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
        let viewModel = WeekViewModel(event: event, factory: self)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    // WeekFactoryInterface
    func makeWeekCellViewModel(date: Date) -> WeekCellViewModel {
        let viewModel = WeekCellViewModel(date: date, event: event)
        viewModel.coordinator = applicationFactory.coordinator
        useCase.add(delegate: viewModel)
        applicationFactory.eventEditUseCase.add(delegate: viewModel)
        return viewModel
    }
}
