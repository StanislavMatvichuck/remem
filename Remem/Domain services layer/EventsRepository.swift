//
//  EventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 03.08.2022.
//

import Foundation

protocol EventsRepositoryInterface {
    func save(_: DomainEvent)
    func save(_: [DomainEvent])
    func all() -> [DomainEvent]
    func delete(_: DomainEvent)
}
