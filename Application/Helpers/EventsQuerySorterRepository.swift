//
//  EventsQuerySorterRepository.swift
//  Application
//
//  Created by Stanislav Matvichuck on 30.05.2023.
//

import Domain
import Foundation

protocol EventsQuerySorterRepository {
    func getCurrent() -> EventsQuerySorter
    func set(current: EventsQuerySorter)
}

struct UserDefaultsEventsQuerySorterRepository: EventsQuerySorterRepository {
    func getCurrent() -> EventsQuerySorter {
        if let orderingString = UserDefaults.standard.string(forKey: "EventsQuerySorter"),
           let ordering = EventsQuerySorter(rawValue: orderingString)
        { return ordering }

        return .alphabetical
    }

    func set(current: EventsQuerySorter) {
        UserDefaults.standard.setValue(current.rawValue, forKey: "EventsQuerySorter")
    }
}
