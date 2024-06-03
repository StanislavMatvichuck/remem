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

    public let hint: Hint
    public let ordering: Ordering
    public let eventsIdentifiers: [String]

    public init(
        eventsReader: EventsReading,
        orderingReader: EventsOrderingReading,
        manualOrderingReader: ManualEventsOrderingReading
    ) {
        let ordering = orderingReader.get()
        var identifiers = eventsReader.identifiers(using: ordering)

        if ordering == .manual {
            let manuallyOrderedIds = manualOrderingReader.get()
            let filteredMOI = manuallyOrderedIds.filter { identifiers.contains($0) }
            let nonOrderedIds = identifiers.filter { !manuallyOrderedIds.contains($0) }
            identifiers = filteredMOI + nonOrderedIds
        }

        self.ordering = ordering
        self.eventsIdentifiers = identifiers
        self.hint = {
            if identifiers.count == 0 { return .createEvent }
            if eventsReader.hasNoHappenings() { return .swipeEvent }
            if eventsReader.hasNoVisitedEvents() { return .checkDetails }
            return .allDone
        }()
    }
}
