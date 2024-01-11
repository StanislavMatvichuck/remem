//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    enum Animation { case none, deleteDropArea }
    static let create = String(localizationId: "button.addHappening")
    static let delete = String(localizationId: "dropToDelete")

    private static let titleFormatter = {
        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = "d MMMM"
        return titleFormatter
    }()

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
    var animation: Animation

    init(
        currentMoment: Date,
        event: Event,
        startOfDay: Date,
        pickerDate: Date?,
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

        self.title = Self.titleFormatter.string(for: startOfDay)!

        self.pickerDate = pickerDate ?? {
            let cal = Calendar.current
            let hour = cal.dateComponents([.hour], from: currentMoment).hour ?? 0
            let minute = cal.dateComponents([.minute], from: currentMoment).minute ?? 0
            return cal.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: startOfDay
            )!
        }()

        self.animation = .none
    }

    func cellAt(index: Int) -> DayCellViewModel {
        let happenings = event.happenings(forDayIndex: DayIndex(startOfDay))
        return factory.makeViewModel(happening: happenings[index])
    }

    mutating func handlePicker(date: Date) { pickerDate = date }
    mutating func enableDrag() { animation = .deleteDropArea }
    mutating func disableDrag() { animation = .none }
}
