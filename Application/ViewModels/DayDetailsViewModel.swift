//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    let create = String(localizationId: "button.addHappening")
    let delete = String(localizationId: "button.delete")

    private let day: DayIndex
    private let commander: EventsCommanding
    private let event: Event
    private let itemFactory: DayItemViewModelFactoring

    let eventId: String
    let items: [DayItemViewModel]
    let title: String
    let isToday: Bool

    init(
        day: DayIndex,
        event: Event,
        isToday: Bool,
        commander: EventsCommanding,
        itemFactory: DayItemViewModelFactoring
    ) {
        self.eventId = event.id
        self.event = event
        self.day = day
        self.commander = commander
        self.itemFactory = itemFactory
        self.isToday = isToday

        let happenings = event.happenings(forDayIndex: day)

        self.items = happenings.map {
            itemFactory.makeViewModel(happening: $0)
        }

        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = "d MMMM"

        self.title = titleFormatter.string(for: day.date)!
    }

    func addHappening(date: Date) {
        event.addHappening(date: date)
        commander.save(event)
    }
}
