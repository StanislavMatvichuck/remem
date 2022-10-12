//
//  EventsRepository.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 14.09.2022.
//

import Domain

public protocol EventsRepositoryInterface {
    func save(_: Event)

    func makeAllEvents() -> [Event]
    func event(byId: String) -> Event?

    func delete(_: Event)
}
