//
//  Updater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.02.2023.
//

import Domain
import Foundation

final class UpdatingEventsCommander: EventsCommanding {
    var delegate: Updating?

    private let commander: EventsCommanding

    init(delegate: Updating? = nil, commander: EventsCommanding) {
        self.delegate = delegate
        self.commander = commander
    }

    func save(_ event: Event) {
        commander.save(event)
        delegate?.update()
    }

    func delete(_ event: Event) {
        commander.delete(event)
        delegate?.update()
    }
}

final class UpdatingEventsSortingCommander: EventsSortingCommanding {
    var delegate: Updating?

    private let commander: EventsSortingCommanding

    init(delegate: Updating? = nil, _ commander: EventsSortingCommanding) {
        self.delegate = delegate
        self.commander = commander
    }

    func set(_ sorter: EventsSorter) {
        commander.set(sorter)
        delegate?.update()
    }
}
