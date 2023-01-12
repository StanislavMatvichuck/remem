//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

protocol EventItemViewModelFactoring {
    func makeEventItemViewModel(
        event: Event,
        today: DayComponents,
        hintEnabled: Bool
    ) -> EventItemViewModel
}

struct EventItemViewModel: EventsListItemViewModel {
    private let event: Event
    private let today: DayComponents
    private let coordinator: Coordinating
    private let commander: EventsCommanding

    var name: String
    var hintEnabled: Bool
    var amount: String

    init(
        event: Event,
        today: DayComponents,
        hintEnabled: Bool,
        coordinator: Coordinating,
        commander: EventsCommanding
    ) {
        self.event = event
        self.today = today
        self.coordinator = coordinator
        self.commander = commander

        self.name = event.name
        self.hintEnabled = hintEnabled
        self.amount = {
            let todayHappeningsCount = event.happenings(forDayComponents: today).count
            return String(todayHappeningsCount)
        }()
    }

    func select() {
        coordinator.show(.eventItem(today: today, event: event))
    }

    func swipe() {
        event.addHappening(date: .now)
        commander.save(event)
    }

    func remove() {
        commander.delete(event)
    }

    func rename(to newName: String) {
        event.name = newName
        commander.save(event)
    }
}
