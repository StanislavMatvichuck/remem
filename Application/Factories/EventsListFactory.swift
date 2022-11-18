//
//  EventsListViewContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation
import IosUseCases

class EventsListFactory {
    // MARK: - Properties
    let applicationFactory: ApplicationFactory
    // MARK: - Init
    init(applicationFactory: ApplicationFactory) {
        self.applicationFactory = applicationFactory
    }

    func makeEventsListController() -> EventsListController {
        let viewRoot = makeView()
        let viewModel = makeEventsListViewModel()
        let controller = EventsListController(
            viewRoot: viewRoot,
            listUseCase: applicationFactory.eventsListUseCase,
            editUseCase: applicationFactory.eventEditUseCase
        )
        return controller
    }

    func makeView() -> EventsListView {
        let view = EventsListView()
        return view
    }

    func makeEventsListViewModel() -> EventsListViewModel {
        let events = applicationFactory.eventsListUseCase.makeAllEvents()
        let viewModel = EventsListViewModel(events: events)
        return viewModel
    }
}
