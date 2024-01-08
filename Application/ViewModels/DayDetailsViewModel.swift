//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    static let create = String(localizationId: "button.addHappening")
    static let delete = String(localizationId: "button.delete")

    private let day: DayIndex
    private let event: Event
    private let itemFactory: DayCellViewModelFactoring

    typealias AddHappeningHandler = (Date) -> Void

    let items: [DayCellViewModel]
    let title: String
    let isToday: Bool
    let addHappeningHandler: AddHappeningHandler
    var pickerDate: Date

    init(
        day: DayIndex,
        event: Event,
        isToday: Bool,
        hour: Int,
        minute: Int,
        itemFactory: DayCellViewModelFactoring,
        addHappeningHandler: @escaping AddHappeningHandler
    ) {
        self.event = event
        self.day = day
        self.itemFactory = itemFactory
        self.addHappeningHandler = addHappeningHandler
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
}
