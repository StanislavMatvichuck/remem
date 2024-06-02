//
//  EventsList.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 27.03.2024.
//

import Foundation

public struct EventsList {
    public enum Hint: CaseIterable { case createEvent, swipeEvent, checkDetails, allDone }
    public enum Ordering: Int, Codable, Equatable, CaseIterable { case name, dateCreated, total, manual }

    public let sorter: Ordering
    public let eventsIdentifiers: [String]
    public let hint: Hint

    public init(
        sorterProvider: EventsOrderingReading,
        manualSorterProvider: ManualEventsOrderingReading,
        eventsProvider: EventsReading
    ) {
        let sorter = sorterProvider.get()
        let manualSorter = manualSorterProvider.get()

        self.sorter = sorter
        self.eventsIdentifiers = eventsProvider.identifiers()
        self.hint = .createEvent
//        self.hint = {
//            if events.count == 0 { return .createEvent }
//            if events.filter({ $0.happenings.count > 0 }).count == 0 { return .swipeEvent }
//            if events.filter({ $0.dateVisited != nil }).count == 0 { return .checkDetails }
//            return .allDone
//        }()
    }
}

public struct EventsSortingExecutor {
    public init() {}

    public func sort(
        events: [Event],
        ordering: EventsList.Ordering,
        manualIdentifiers: [String] = []
    ) -> [Event] {
        switch ordering {
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
