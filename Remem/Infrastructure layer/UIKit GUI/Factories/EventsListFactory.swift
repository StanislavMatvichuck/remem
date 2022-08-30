//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import UIKit

class EventsListFactory: EventsListFactoryInterface {
    // MARK: - Properties
    let coordinator: Coordinator
    let coordinatorFactory: CoordinatorFactory

    var eventsListUseCase: EventsListUseCase { coordinatorFactory.eventsListUseCase }
    var eventEditUseCase: EventEditUseCase { coordinatorFactory.eventEditUseCase }
    var eventsListMulticastDelegate: MulticastDelegate<EventsListUseCaseOutput> { coordinatorFactory.eventsListMulticastDelegate }
    var eventEditMulticastDelegate: MulticastDelegate<EventEditUseCaseOutput> { coordinatorFactory.eventEditMulticastDelegate }
    // MARK: - Init
    init(coordinatorFactory: CoordinatorFactory, coordinator: Coordinator) {
        self.coordinatorFactory = coordinatorFactory
        self.coordinator = coordinator
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
        let viewModel = EventsListViewModel(listUseCase: eventsListUseCase,
                                            editUseCase: eventEditUseCase)
        eventsListMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = coordinator
        return viewModel
    }

    func makeEventCellViewModel(event: Event) -> EventCellViewModel {
        let viewModel = EventCellViewModel(event: event, editUseCase: eventEditUseCase)
        eventEditMulticastDelegate.addDelegate(viewModel)
        viewModel.coordinator = coordinator
        return viewModel
    }
}
