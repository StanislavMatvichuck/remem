//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

struct Event {
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

        let newHappening = Happening(dateCreated: date)
        happenings.append(newHappening)

        return newHappening
    }

    mutating
    func visit() {
        dateVisited = Date.now
    }
}
