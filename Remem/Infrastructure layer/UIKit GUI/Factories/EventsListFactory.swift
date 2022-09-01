//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import UIKit

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
        let view = EventsListView()
        let viewModel = makeEventsListViewModel()
        let controller = EventsListController(view: view,
                                              viewModel: viewModel,
                                              factory: self)
        viewModel.delegate = controller
        return controller
    }

    func makeEventsListViewModel() -> EventsListViewModel {
        let viewModel = EventsListViewModel(listUseCase: applicationFactory.eventsListUseCase,
                                            editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventsListMulticastDelegate.addDelegate(viewModel)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }

    func makeEventCellViewModel(event: Event) -> EventCellViewModel {
        let viewModel = EventCellViewModel(event: event, editUseCase: applicationFactory.eventEditUseCase)
        applicationFactory.eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = applicationFactory.coordinator
        return viewModel
    }
}
