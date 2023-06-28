//
//  EventsQuerySorterRepository.swift
//  Application
//
//  Created by Stanislav Matvichuck on 30.05.2023.
//

import Domain
import Foundation

protocol EventsQuerySorterRepository {
    func get() -> EventsQuerySorter
    func set(current: EventsQuerySorter)
}

struct UserDefaultsEventsQuerySorterRepository: EventsQuerySorterRepository {
    private var defaults: UserDefaults { UserDefaults.standard }
    private static let key = "EventsQuerySorter"

    func get() -> EventsQuerySorter {
        if let orderingString = defaults.string(forKey: Self.key),
           let ordering = EventsQuerySorter(rawValue: orderingString)
        {
            return ordering
        }

        return .alphabetical
    }

    func set(current: EventsQuerySorter) {
        defaults.setValue(current.rawValue, forKey: Self.key)
    }
}
