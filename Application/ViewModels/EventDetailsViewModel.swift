//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation

struct EventDetailsViewModel {
    private let event: Event
    private let commander: EventsCommanding

    init(
        event: Event,
        commander: EventsCommanding
    ) {
        self.event = event
        self.commander = commander
    }

    var title: String { event.name }
    var isVisited: Bool { event.dateVisited != nil }

    func visit() {
        event.visit()
        commander.save(event)
    }
}
