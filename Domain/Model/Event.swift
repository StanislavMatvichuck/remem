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

public class Event {
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

    func happenings(forDay: Date) -> [Happening] {
        happenings
            .filter { $0.dateCreated.isInSameDay(as: forDay) }
            .sorted(by: { $0.dateCreated > $1.dateCreated })
    }
}

// MARK: - Equatable
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
