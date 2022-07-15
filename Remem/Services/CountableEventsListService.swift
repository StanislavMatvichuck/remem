//
//  CountableEventsListService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.07.2022.
//

import Foundation

class CountableEventsListService {
    typealias Repository = CountableEventsRepository

    // MARK: - Properties
    private var repository: Repository

    // MARK: - Init
    init(_ repository: Repository) {
        self.repository = repository
    }
}

// MARK: - Public
extension CountableEventsListService {
    func add(name: String) { repository.make(name: name) }

    func delete(at index: Int) {
        guard let countableEvent = repository.countableEvent(at: index) else { return }
        repository.delete(countableEvent)
    }

    func get(at index: Int) -> CountableEvent? { repository.countableEvent(at: index) }

    func makeHappening(at index: Int) {
        guard let countableEvent = repository.countableEvent(at: index) else { return }
        repository.makeCountableEventHappeningDescription(at: countableEvent, dateTime: .now)
    }

    func getList() -> [CountableEvent] { repository.getList() }
}
