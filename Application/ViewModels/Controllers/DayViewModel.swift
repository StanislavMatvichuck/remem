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

struct DayViewModel {
    let create = String(localizationId: "button.create")
    let delete = String(localizationId: "button.delete")
    let cancel = String(localizationId: "button.cancel")
    let edit = String(localizationId: "button.edit")

    let day: DayComponents
    private let commander: EventsCommanding
    let event: Event

    let items: [DayItemViewModel]
    let itemsFactory: DayItemViewModelFactoring
    var pickerDate: Date

    init(
        day: DayComponents,
        event: Event,
        commander: EventsCommanding,
        factory: DayItemViewModelFactoring
    ) {
        self.event = event
        self.day = day
        self.commander = commander
        self.itemsFactory = factory
        self.pickerDate = day.date

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happenings = event.happenings(forDayComponents: day)
        self.items = happenings.map {
            factory.makeDayItemViewModel(event: event, happening: $0)
        }
    }

    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(for: day.date)
    }

    func addHappening() {
        event.addHappening(date: pickerDate)
        commander.save(event)
    }
}
