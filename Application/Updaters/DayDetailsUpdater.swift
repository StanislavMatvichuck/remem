//
//  DayUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DisplayingDayDetailsViewModel {
    func update(_: DayDetailsViewModel)
}

extension DayDetailsViewController: DisplayingDayDetailsViewModel {
    func update(_ vm: DayDetailsViewModel) {
        viewModel = vm
    }
}

final class DayDetailsUpdater: MulticastDelegate<DisplayingDayDetailsViewModel> {
    private let decorated: EventsCommanding

    var factory: DayViewModelFactoring?

    init(decoratedInterface: EventsCommanding) {
        self.decorated = decoratedInterface
    }

    func add(receiver: DisplayingDayDetailsViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        call { $0.update(factory.makeViewModel()) }
    }
}

extension DayDetailsUpdater: EventsCommanding {
    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }
}
