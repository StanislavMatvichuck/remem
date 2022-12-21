//
//  EventsListViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2022.
//

import Domain

protocol UsingEventsListViewModel {
    var viewModel: EventsListViewModel { get }
    func update(viewModel: EventsListViewModel)
}

protocol EventsListViewModelUpdateDispatcher {
    func addUpdateReceiver(_: UsingEventsListViewModel)
}

class EventsCommandingEventsListViewModelUpdatingDecorator:
    MulticastDelegate<UsingEventsListViewModel>,
    EventsListViewModelUpdateDispatcher,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding

    init(decoratedInterface: EventsCommanding) {
        self.decoratedInterface = decoratedInterface
    }

    func save(_ event: Domain.Event) {
        decoratedInterface.save(event)
        sendUpdates()
    }

    func delete(_ event: Domain.Event) {
        decoratedInterface.delete(event)
        sendUpdates()
    }

    func addUpdateReceiver(_ receiver: UsingEventsListViewModel) {
        addDelegate(receiver)
    }

    private func sendUpdates() {
        call { viewModelUpdateReceiver in
            
            viewModelUpdateReceiver.update(
                viewModel: viewModelUpdateReceiver.viewModel.copy()
            )
            
        }
    }
}
