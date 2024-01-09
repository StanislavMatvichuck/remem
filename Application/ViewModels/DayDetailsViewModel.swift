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

    private let event: Event
    private let factory: DayCellViewModelFactoring

    typealias AddHappeningHandler = (Date) -> Void

    let title: String
    let isToday: Bool
    let addHappeningHandler: AddHappeningHandler
    let cellsCount: Int
    let currentMoment: Date
    let startOfDay: Date
    var pickerDate: Date

    init(
        currentMoment: Date,
        event: Event,
        startOfDay: Date,
        factory: DayCellViewModelFactoring,
        addHappeningHandler: @escaping AddHappeningHandler
    ) {
        self.event = event
        self.factory = factory
        self.currentMoment = currentMoment
        self.addHappeningHandler = addHappeningHandler
        self.isToday = DayIndex(currentMoment).date == startOfDay
        self.startOfDay = startOfDay
        self.cellsCount = event.happenings(forDayIndex: DayIndex(startOfDay)).count

        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = "d MMMM"

        self.title = titleFormatter.string(for: startOfDay)!

        let hour = 0
        let minute = 0
        self.pickerDate = Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: startOfDay
        )!
    }

    func cellAt(index: Int) -> DayCellViewModel {
        let happenings = event.happenings(forDayIndex: DayIndex(startOfDay))
        return factory.makeViewModel(happening: happenings[index])
    }
}
