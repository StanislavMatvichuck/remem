//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

struct Event: Equatable {
    let id: String
    var name: String
    var happenings: [Happening]

    let dateCreated: Date
    var dateVisited: Date?
}

enum EventManipulationError: Error {
    case incorrectHappeningDate
    case invalidHappeningDeletion
}

// MARK: - Public
extension Event {
    @discardableResult mutating
    func addHappening(date: Date) throws -> Happening {
        if date < dateCreated { throw EventManipulationError.incorrectHappeningDate }

        let insertIndex = happenings.firstIndex { happening in
            happening.dateCreated < date
        } ?? 0

        let newHappening = Happening(dateCreated: date)
        happenings.insert(newHappening, at: insertIndex)

        return newHappening
    }

    mutating
    func visit() {
        dateVisited = Date.now
    }

    mutating
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

    // MARK: - Factory method
    static func make(name: String) -> Event {
        let id = UUID().uuidString
        let happenings = [Happening]()

        let dateCreated: Date = {
            let c = Calendar.current
            let creationDate = Date.now
            var components = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: creationDate)
            components.hour = 0
            components.minute = 0
            components.second = 0

            if let date = c.date(from: components) { return date }
            else { return creationDate }
        }()

        return Event(id: id,
                     name: name,
                     happenings: happenings,
                     dateCreated: dateCreated)
    }
}
