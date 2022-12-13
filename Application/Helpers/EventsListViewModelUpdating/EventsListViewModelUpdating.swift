//
//  EventsListViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2022.
//

import Domain

protocol EventsListViewModelUpdating { func update(viewModel: EventsListViewModel) }

class EventsCommandingUIUpdatingDecorator: EventsCommanding {
    let decoratee: EventsCommanding
    let updater: EventsListViewModelUpdating
    var viewModelFactory: (() -> EventsListViewModel)?

    init(
        decoratee: EventsCommanding,
        updater: EventsListViewModelUpdating
    ) {
        self.decoratee = decoratee
        self.updater = updater
    }

    func save(_ event: Domain.Event) {
        decoratee.save(event)
        sendUpdates()
    }

    func delete(_ event: Domain.Event) {
        decoratee.delete(event)
        sendUpdates()
    }

    private func sendUpdates() {
        guard let viewModelFactory else { return }
        updater.update(viewModel: viewModelFactory())
    }
}

class EventsListsUpdater:
    MulticastDelegate<EventsListViewModelUpdating>,
    EventsListViewModelUpdating
{
    func update(viewModel: EventsListViewModel) {
        call { $0.update(viewModel: viewModel) }
    }
}
