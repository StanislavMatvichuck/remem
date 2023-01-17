//
//  EventsListUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2023.
//

import Domain

final class EventsListUpdater: MulticastDelegate<UsingEventsListViewModel>, EventsCommanding {
    /// `CompositionRoot` is a factory. Is it possible to avoid this cycle and use initializer injection?
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

    func add(receiver: UsingEventsListViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        let newViewModel = factory.makeEventsListViewModel(events: provider.get())
        call { $0.update(viewModel: newViewModel) }
    }
}


