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

    static func make(name: String) -> Event {
        let id = UUID().uuidString
        let happenings = [Happening]()
        let dateCreated = Date.now

        return Event(id: id,
                     name: name,
                     happenings: happenings,
                     dateCreated: dateCreated)
    }
}
