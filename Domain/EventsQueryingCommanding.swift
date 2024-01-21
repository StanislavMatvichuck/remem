//
//  EventsRepository.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 14.09.2022.
//

import Foundation

public enum EventsSorter: Codable, Equatable, CaseIterable {
    public static var allCases: [EventsSorter] = [
        .alphabetical,
        .happeningsCountTotal,
        .manual(identifiers: [])
    ]

    case alphabetical
    case happeningsCountTotal
    case manual(identifiers: [String])
}

public protocol EventsQuerying {
    func get() -> [Event]
}

public protocol EventsCommanding {
    func save(_: Event)
    func delete(_: Event)
}

public protocol EventsSortingQuerying {
    func get() -> EventsSorter
}

public protocol EventsSortingCommanding {
    func set(_: EventsSorter)
}
