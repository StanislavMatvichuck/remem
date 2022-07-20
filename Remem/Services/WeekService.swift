//
//  WeekService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import Foundation

class WeekService {
    typealias Repository = HappeningsRepository

    // MARK: - Properties
    private var repository: Repository

    // MARK: - Init
    init(_ repository: Repository) {
        self.repository = repository
    }
}

// MARK: - Public
extension WeekService {
    func weekList(for event: Event) -> WeekList {
        let happenings = get(for: event)
        return makeWeekList(for: happenings)
    }
}

// MARK: - Private
extension WeekService {
    private func get(for event: Event) -> [Happening] {
        guard
            let start = event.dateCreated,
            let end = Date.now.endOfWeek
        else { return [] }

        return repository.getHappenings(for: event, between: start, and: end)
    }

    private func makeWeekList(for happenings: [Happening]) -> WeekList {
        return WeekList(days: [
            WeekDay(amount: 1, dayNumber: 1, isToday: false),
            WeekDay(amount: 2, dayNumber: 1, isToday: false),
            WeekDay(amount: 3, dayNumber: 1, isToday: false),
            WeekDay(amount: 4, dayNumber: 1, isToday: false),
            WeekDay(amount: 5, dayNumber: 1, isToday: false),
            WeekDay(amount: 6, dayNumber: 1, isToday: false),
            WeekDay(amount: 7, dayNumber: 1, isToday: false),
        ])
    }
}
