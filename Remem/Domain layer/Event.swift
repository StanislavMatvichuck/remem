//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

class Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.dateVisited == rhs.dateVisited &&
            lhs.happenings == rhs.happenings
    }

    let id: String
    var name: String
    var happenings: [Happening]

    let dateCreated: Date
    var dateVisited: Date?

    // MARK: - Init
    init(name: String) {
        self.name = name

        id = UUID().uuidString
        happenings = [Happening]()
        dateCreated = {
            let c = Calendar.current
            let creationDate = Date.now
            var components = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: creationDate)
            components.hour = 0
            components.minute = 0
            components.second = 0

            if let date = c.date(from: components) { return date }
            else { return creationDate }
        }()
    }

    init(id: String,
         name: String,
         happenings: [Happening],
         dateCreated: Date,
         dateVisited: Date?)
    {
        self.id = id
        self.name = name
        self.happenings = happenings
        self.dateCreated = dateCreated
        self.dateVisited = dateVisited
    }
}

enum EventManipulationError: Error {
    case incorrectHappeningDate
    case invalidHappeningDeletion
}

// MARK: - Public
extension Event {
    @discardableResult
    func addHappening(date: Date) throws -> Happening {
        if date < dateCreated { throw EventManipulationError.incorrectHappeningDate }

        let insertIndex = happenings.firstIndex { happening in
            happening.dateCreated < date
        } ?? 0

        let newHappening = Happening(dateCreated: date)
        happenings.insert(newHappening, at: insertIndex)

        return newHappening
    }

    func visit() {
        dateVisited = Date.now
    }

    func remove(happening: Happening) throws {
        var happeningDeleted = false

        for (index, existingHappening) in happenings.enumerated() {
            if existingHappening == happening {
                happenings.remove(at: index)
                happeningDeleted = true
                break
            }
        }

        if !happeningDeleted { throw EventManipulationError.invalidHappeningDeletion }
    }
}
