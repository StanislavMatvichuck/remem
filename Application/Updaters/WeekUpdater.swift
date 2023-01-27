//
//  WeekUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain

protocol DisplayingWeekViewModel {
    func update(_: WeekViewModel)
}

extension WeekViewController: DisplayingWeekViewModel {
    func update(_ vm: WeekViewModel) {
        viewModel = vm
    }
}

final class WeekUpdater: MulticastDelegate<DisplayingWeekViewModel> {
    private let decorated: EventsCommanding

    var factory: WeekViewModelFactoring?

    init(decoratedInterface: EventsCommanding) {
        self.decorated = decoratedInterface
    }

    func add(receiver: DisplayingWeekViewModel) {
        addDelegate(receiver)
    }

    func update() {
        guard let factory else { fatalError("updater requires factory") }
        call { $0.update(factory.makeViewModel()) }
    }
}

// MARK: - EventsCommanding
extension WeekUpdater: EventsCommanding {
    func save(_ event: Domain.Event) {
        decorated.save(event)
        update()
    }

    func delete(_ event: Domain.Event) {
        decorated.delete(event)
        update()
    }
}
