//
//  EventsRepository.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 14.09.2022.
//

public protocol EventsRepositoryInterface {
    func makeAllEvents() -> [Event]
    func save(_: Event)
    func delete(_: Event)
}
