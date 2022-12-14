//
//  EventsListViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2022.
//

import Domain

protocol EventsListViewModelUpdating {
    func update(viewModel: EventsListViewModel)
}

protocol EventsListViewModelUpdateDispatcher {
    func addUpdateReceiver(_: EventsListViewModelUpdating)
}

class EventsCommandingEventsListViewModelUpdatingDecorator:
    MulticastDelegate<EventsListViewModelUpdating>,
    EventsListViewModelUpdateDispatcher,
    EventsListViewModelUpdating,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding
    var viewModelFactory: (() -> EventsListViewModel)?

    init(decoratedInterface: EventsCommanding) { self.decoratedInterface = decoratedInterface }

    func save(_ event: Domain.Event) {
        decoratedInterface.save(event)
        sendUpdates()
    }

    func delete(_ event: Domain.Event) {
        decoratedInterface.delete(event)
        sendUpdates()
    }

    func addUpdateReceiver(_ receiver: EventsListViewModelUpdating) {
        addDelegate(receiver)
    }

    func update(viewModel: EventsListViewModel) {
        call { $0.update(viewModel: viewModel) }
    }

    private func sendUpdates() {
        guard let viewModelFactory else { return }
        update(viewModel: viewModelFactory())
    }
}
