//
//  DomainFacade.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.07.2022.
//

import Foundation

class DomainFacade {
    typealias EventUpdateCallback = (Event) -> Void

    private let eventsRepository = EventsRepository()
}

// MARK: - Public
extension DomainFacade {
    func getEvents() -> [Event] { eventsRepository.getList() }

    func visit(event: Event, callback: @escaping EventUpdateCallback) {
        eventsRepository.visit(event)
        callback(event)
    }
}
