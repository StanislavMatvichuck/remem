//
//  EventsListService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Foundation

class EventsListService {
    typealias Repository = EventsRepository

    // MARK: - Properties
    private var repository: Repository

    // MARK: - Init
    init(_ repository: Repository) {
        self.repository = repository
    }
}

// MARK: - Public
extension EventsListService {
    func add(name: String) { repository.make(name: name) }

    func delete(at index: Int) {
        guard let event = repository.event(at: index) else { return }
        repository.delete(event)
    }

    func get(at index: Int) -> Event? { repository.event(at: index) }

    func makeHappening(at index: Int) {
        guard let event = repository.event(at: index) else { return }
        repository.makeHappening(at: event, dateTime: .now)
    }

    func getList() -> [Event] { repository.getList() }
}
