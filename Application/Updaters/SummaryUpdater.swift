//
//  File.swift
//  Application
//
//  Created by Stanislav Matvichuck on 02.02.2023.
//

import Domain

protocol DisplayingSummaryViewModel {
    func update(_: SummaryViewModel)
}

extension SummaryViewController: DisplayingSummaryViewModel {
    func update(_ vm: SummaryViewModel) {
        viewModel = vm
    }
}

final class SummaryUpdater: MulticastDelegate<DisplayingSummaryViewModel> {
    private let decorated: EventsCommanding

    var factory: SummaryViewModelFactoring?

    init(decoratedInterface: EventsCommanding) {
        self.decorated = decoratedInterface
    }

    func add(receiver: DisplayingSummaryViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        call { $0.update(factory.makeViewModel()) }
    }
}

// MARK: - EventsCommanding
extension SummaryUpdater: EventsCommanding {
    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }
}
