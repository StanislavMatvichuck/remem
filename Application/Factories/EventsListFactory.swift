//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation
import IosUseCases

protocol EventsListFactoryInterface {
    func makeEventCellViewModel(event: Event) -> EventCellViewModel
}

class EventsListFactory: EventsListFactoryInterface {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    // MARK: - Init
    init(applicationFactory: ApplicationFactory) {
        self.applicationFactory = applicationFactory
    }

    func makeEventsListController() -> EventsListController {
        let viewRoot = makeView()
        let viewModel = makeEventsListViewModel()
        let controller = EventsListController(viewRoot: viewRoot, viewModel: viewModel)
        viewModel.delegate = controller
        return controller
    }

    func makeView() -> EventsListView {
        let view = EventsListView()
        return view
    }

    func makeEventsListViewModel() -> EventsListViewModel {
        let viewModel = EventsListViewModel(listUseCase: applicationFactory.eventsListUseCase,
                                            editUseCase: applicationFactory.eventEditUseCase,
                                            factory: self)
        applicationFactory.eventsListUseCase.add(delegate: viewModel)
        applicationFactory.eventEditUseCase.add(delegate: viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    // EventsListFactoryInterface
    func makeEventCellViewModel(event: Event) -> EventCellViewModel {
        let viewModel = EventCellViewModel(event: event, editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventEditUseCase.add(delegate: viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }
}
