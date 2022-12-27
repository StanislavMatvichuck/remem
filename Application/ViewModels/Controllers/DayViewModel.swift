//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

protocol DayItemViewModelFactoring {
    func makeDayItemViewModel(event: Event, happening: Happening) -> DayItemViewModel
}

protocol DayViewModelFactoring {
    func makeDayViewModel(event: Event, day: DayComponents) -> DayViewModel
}

struct DayViewModel: EventDependantViewModel {
    let create = String(localizationId: "button.create")
    let delete = String(localizationId: "button.delete")
    let cancel = String(localizationId: "button.cancel")
    let edit = String(localizationId: "button.edit")

    private let day: DayComponents
    private let commander: EventsCommanding
    private let event: Event
    private let itemsFactory: DayItemViewModelFactoring
    private let selfFactory: DayViewModelFactoring

    /// Used by `DayViewModelUpdating`
    let eventId: String
    let items: [DayItemViewModel]
    let title: String?
    var pickerDate: Date
    var readableTime: String?

    init(
        day: DayComponents,
        event: Event,
        commander: EventsCommanding,
        itemsFactory: DayItemViewModelFactoring,
        selfFactory: DayViewModelFactoring
    ) {
        self.eventId = event.id
        self.event = event
        self.day = day
        self.commander = commander
        self.itemsFactory = itemsFactory
        self.selfFactory = selfFactory
        self.pickerDate = day.date

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happenings = event.happenings(forDayComponents: day)
        self.items = happenings.map {
            itemsFactory.makeDayItemViewModel(event: event, happening: $0)
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

    func copy(newEvent: Event) -> DayViewModel {
        selfFactory.makeDayViewModel(event: newEvent, day: day)
    }
}
