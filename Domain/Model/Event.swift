//
//  Domain.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

import Foundation

public enum EventManipulationError: Error {
    case invalidHappeningDeletion
}

public class Event: CustomDebugStringConvertible {
    public let id: String
    public var name: String
    public var happenings: [Happening]

    public let dateCreated: Date
    public var dateVisited: Date?

    // MARK: - Init
    public convenience init(name: String) {
        self.init(
            id: UUID().uuidString,
            name: name,
            happenings: [Happening](),
            dateCreated: .now,
            dateVisited: nil
        )
    }

    public convenience init(name: String, dateCreated: Date) {
        self.init(
            id: UUID().uuidString,
            name: name,
            happenings: [Happening](),
            dateCreated: dateCreated,
            dateVisited: nil
        )
    }

    /// Used by DataLayer only
    public init(
        id: String,
        name: String,
        happenings: [Happening],
        dateCreated: Date,
        dateVisited: Date?
    ) {
        self.id = id
        self.name = name
        self.happenings = happenings
        self.dateCreated = dateCreated
        self.dateVisited = dateVisited
    }

    public var debugDescription: String {
        """
        name: \(name)
        dateCreated: \(dateCreated.debugDescription)
        happeningsCount: \(happenings.count)
        """
    }
}

// MARK: - Public
public extension Event {
    @discardableResult func addHappening(date: Date) -> Happening {
        let insertIndex = happenings.firstIndex {
            happening in happening.dateCreated < date
        } ?? 0

        let newHappening = Happening(dateCreated: date)
        happenings.insert(newHappening, at: insertIndex)

        return newHappening
    }

    func visit(at date: Date = .now) { dateVisited = date }

    @discardableResult func remove(happening: Happening) throws -> Happening? {
        var happeningDeleted: Happening?

        for (index, existingHappening) in happenings.enumerated() {
            if existingHappening == happening {
                happeningDeleted = happenings.remove(at: index)
                break
            }
        }

        if happeningDeleted == nil { throw EventManipulationError.invalidHappeningDeletion }

        return happeningDeleted
    }

    func happenings(forDayComponents day: DayComponents) -> [Happening] {
        let startOfDay = Calendar.current.startOfDay(for: day.date)

        var endOfDayComponents = day.value
        endOfDayComponents.hour = 23
        endOfDayComponents.minute = 59
        endOfDayComponents.second = 59

        guard let endOfDayDate = Calendar.current.date(from: endOfDayComponents) else { return [] }

        return happenings.filter {
            $0.dateCreated >= startOfDay &&
                $0.dateCreated < endOfDayDate
        }
    }
}

// MARK: - Equatable
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
