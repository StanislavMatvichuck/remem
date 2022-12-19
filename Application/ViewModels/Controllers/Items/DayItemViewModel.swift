//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayItemViewModel {
    private let event: Event
    private let happening: Happening
    private let commander: EventsCommanding

    let text: String

    init(
        event: Event,
        happening: Happening,
        commander: EventsCommanding
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        self.commander = commander
        self.event = event
        self.happening = happening
        self.text = dateFormatter.string(from: happening.dateCreated)
    }

    func remove() {
        do { try event.remove(happening: happening) } catch {}
        commander.save(event)
    }
}
