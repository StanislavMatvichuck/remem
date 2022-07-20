//
//  EventDetailsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

class EventDetailsService {
    typealias Repository = EventsRepository

    // MARK: - Properties
    private var repository: Repository

    // MARK: - Init
    init(_ repository: Repository) {
        self.repository = repository
    }
}

// MARK: - Public
extension EventDetailsService {
    func visit(_ event: Event) { repository.visit(event) }
}
