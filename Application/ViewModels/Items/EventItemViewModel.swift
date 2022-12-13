//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventItemViewModel {
    let event: Event
    let today: DayComponents
    let coordinator: Coordinating
    let commander: EventsCommanding

    init(
        event: Event,
        today: DayComponents,
        coordinator: Coordinating,
        commander: EventsCommanding
    ) {
        self.event = event
        self.today = today
        self.coordinator = coordinator
        self.commander = commander
    }

    var name: String { event.name }

    var amount: String {
        let todayHappeningsCount = event.happenings(forDayComponents: today).count
        return String(todayHappeningsCount)
    }

    func select() {
        coordinator.show(.eventItem(event: event))
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
