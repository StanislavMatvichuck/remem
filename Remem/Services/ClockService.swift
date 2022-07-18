//
//  ClockService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.07.2022.
//

import Foundation

class ClockService {
    typealias Repository = HappeningsRepository

    // MARK: - Properties
    private var repository: Repository

    // MARK: - Init
    init(_ repository: Repository) {
        self.repository = repository
    }
}

// MARK: - Public
extension ClockService {
    func getList(
        for event: Event,
        between start: Date,
        and end: Date)
        -> [Happening]
    {
        repository.getHappenings(for: event, between: start, and: end)
    }
}
