//
//  EventsListUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2023.
//

import Domain

protocol DisplayingEventsListViewModel {
    func update(viewModel: EventsListViewModel)
}

extension EventsListViewController: DisplayingEventsListViewModel {
    func update(viewModel: EventsListViewModel) {
        self.viewModel = viewModel
    }
}

final class EventsListUpdater: MulticastDelegate<DisplayingEventsListViewModel>, EventsCommanding {
    var factory: EventsListViewModelFactoring?
    private let decorated: EventsCommanding
    private let provider: EventsQuerying
    init(decorated: EventsCommanding, eventsProvider: EventsQuerying) {
        self.decorated = decorated
        self.provider = eventsProvider
    }

    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }

    func add(receiver: DisplayingEventsListViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        let newViewModel = factory.makeEventsListViewModel(events: provider.get())
        call { $0.update(viewModel: newViewModel) }
    }
}
