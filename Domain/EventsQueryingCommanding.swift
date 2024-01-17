//
//  EventsRepository.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 14.09.2022.
//

import Foundation

public enum EventsSorter: Codable, Equatable {
    case alphabetical
    case happeningsCountTotal
    case manual(identifiers: [String])
}

public protocol EventsQuerying {
    func get() -> [Event]
    func get(using: EventsSorter) -> [Event]
}

public protocol EventsCommanding {
    func save(_: Event)
    func delete(_: Event)
}

public protocol EventsSorterQuerying {
    func get() -> EventsSorter
}

public protocol EventsSorterCommanding {
    func set(_: EventsSorter)
}
