//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    let create = String(localizationId: "button.create")
    let delete = String(localizationId: "button.delete")
    let cancel = String(localizationId: "button.cancel")
    let edit = String(localizationId: "button.edit")

    private let day: DayIndex
    private let commander: EventsCommanding
    private let event: Event

    /// Used by `DayViewModelUpdating`
    let eventId: String
    let items: [DayItemViewModel]
    let title: String?
    var pickerDate: Date
    var readableTime: String?

    init(
        day: DayIndex,
        event: Event,
        commander: EventsCommanding,
        itemFactory: DayItemViewModelFactoring
    ) {
        self.eventId = event.id
        self.event = event
        self.day = day
        self.commander = commander
        self.pickerDate = day.date

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happenings = event.happenings(forDayIndex: day)

        self.items = happenings.map {
            itemFactory.makeViewModel(happening: $0)
        }

        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = "d MMMM"

        self.title = titleFormatter.string(for: day.date)

        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short

        self.readableTime = timeFormatter.string(for: day.date)
    }

    func addHappening() {
        event.addHappening(date: pickerDate)
        commander.save(event)
    }

    mutating func update(pickerDate: Date) {
        self.pickerDate = pickerDate
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        readableTime = timeFormatter.string(for: pickerDate)
    }
}
