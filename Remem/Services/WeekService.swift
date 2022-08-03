//
//  WeekService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import Foundation

class WeekService {
    // MARK: - Properties
    private var repository = HappeningsRepository()
    private var event: CDEvent

    // MARK: - Init
    init(_ event: CDEvent) {
        self.event = event
    }
}

// MARK: - Public
extension WeekService {
    func weekList() -> WeekList? {
        let happenings = get(for: event)
        return makeWeekList(for: happenings)
    }
}

// MARK: - Private
extension WeekService {
    private func get(for event: CDEvent) -> [CDHappening] {
        guard
            let start = event.dateCreated,
            let end = Date.now.endOfWeek
        else { return [] }

        return repository.getHappenings(for: event, between: start, and: end)
    }

    private func makeWeekList(for happenings: [CDHappening]) -> WeekList? {
        guard
            let dateStart = event.dateCreated?.startOfWeek,
            let dateEnd = Date.now.endOfWeek
        else { return nil }

        let list = WeekList(from: dateStart, to: dateEnd, happenings: happenings)

        return list
    }
}
