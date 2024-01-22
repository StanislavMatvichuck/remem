//
//  EventsSortingExecutor.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

import Domain
import Foundation

struct EventsSortingExecutor {
    func sort(events: [Event], sorter: EventsSorter) -> [Event] {
        switch sorter {
        case .name: sortByName(events)
        case .total: sortByTotal(events)
        default: fatalError("sorter not supported yet")
        }
    }

    private func sortByTotal(_ events: [Event]) -> [Event] {
        events.sorted { prevEvent, nextEvent in
            prevEvent.happenings.count > nextEvent.happenings.count
        }
    }

    private func sortByName(_ events: [Event]) -> [Event] {
        events.sorted { prevEvent, nextEvent in
            prevEvent.name < nextEvent.name
        }
    }
}
