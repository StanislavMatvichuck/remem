//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

struct DomainEvent {
    let id: String
    var name: String
    var happenings: [DomainHappening]

    let dateCreated: Date
    var dateVisited: Date?
}

struct DomainHappening {
    let dateCreated: Date
    var value: Int32 = 1
}
