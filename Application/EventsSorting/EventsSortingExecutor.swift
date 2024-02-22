//
//  EventsSortingExecutor.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

import Domain
import Foundation

struct EventsSortingExecutor {
    func sort(
        events: [Event],
        sorter: EventsSorter,
        manualIdentifiers: [String] = []
    ) -> [Event] {
        switch sorter {
        case .name: sortByName(events)
        case .total: sortByTotal(events)
        case .manual: sortManually(events, manualIdentifiers)
        case .dateCreated: sortByDateCreated(events)
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
    
    private func sortManually(_ events: [Event], _ identifiers: [String]) -> [Event] {
        var processedEvents = events
        var sortedEvents = [Event]()
        
        for identifier in identifiers {
            if let (index, existingIncomingEvent) = processedEvents.enumerated().first(where: { _, event in
                event.id == identifier
            }) {
                sortedEvents.append(existingIncomingEvent)
                processedEvents.remove(at: index)
            }
        }
        
        // adding new events to the end
        sortedEvents.append(contentsOf: processedEvents)
        
        return sortedEvents
    }
    
    private func sortByDateCreated(_ events: [Event]) -> [Event] {
        events.sorted { prevEvent, nextEvent in
            prevEvent.dateCreated < nextEvent.dateCreated
        }
    }
}
