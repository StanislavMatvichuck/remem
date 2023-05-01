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

    let items: [DayCellViewModel]
    let title: String
    let isToday: Bool
    var pickerDate: Date

    init(
        day: DayIndex,
        event: Event,
        isToday: Bool,
        hour: Int,
        minute: Int,
        commander: EventsCommanding,
        itemFactory: DayItemViewModelFactoring
    ) {
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

        let dayDate = day.date
        self.pickerDate = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: dayDate
        )!
    }

    func addHappening(date: Date) {
        event.addHappening(date: date)
        commander.save(event)
    }
}
