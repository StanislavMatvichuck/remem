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
        let newHappening = Happening(dateCreated: date)

        if let insertIndex = happenings.lastIndex(where: { $0.dateCreated <= date }) {
            happenings.insert(newHappening, at: insertIndex + 1)
            return newHappening
        }

        happenings.insert(newHappening, at: 0)
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
}

// MARK: - Equatable
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
