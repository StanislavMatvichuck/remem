//
//  EventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 03.08.2022.
//

import Foundation

protocol EventsRepositoryInterface {
    func save(_: Event)
    func save(_: [Event])

    func all() -> [Event]
    func event(byId: String) -> Event?

    func delete(_: Event)
}
