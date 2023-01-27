//
//  ClockUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DisplayingClockViewModel {
    func update(_: ClockViewModel)
}

extension ClockViewController: DisplayingClockViewModel {
    func update(_ vm: ClockViewModel) {
        viewModel = vm
    }
}

final class ClockUpdater: MulticastDelegate<DisplayingClockViewModel> {
    private let decorated: EventsCommanding

    var factory: ClockViewModelFactoring?

    init(decoratedInterface: EventsCommanding) {
        self.decorated = decoratedInterface
    }

    func add(receiver: DisplayingClockViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        call { $0.update(factory.makeViewModel()) }
    }
}

extension ClockUpdater: EventsCommanding {
    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }
}
