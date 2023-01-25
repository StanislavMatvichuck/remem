//
//  DayUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DisplayingDayViewModel {
    func update(_: DayViewModel)
}

extension DayViewController: DisplayingDayViewModel {
    func update(_ vm: DayViewModel) {
        viewModel = vm
    }
}

final class DayUpdater: MulticastDelegate<DisplayingDayViewModel> {
    private let decorated: EventsCommanding

    var factory: DayViewModelFactoring?

    init(decoratedInterface: EventsCommanding) {
        self.decorated = decoratedInterface
    }

    func add(receiver: DisplayingDayViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        call { $0.update(factory.makeViewModel()) }
    }
}

extension DayUpdater: EventsCommanding {
    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }
}
