//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    static let create = String(localizationId: localizationIdButtonAddHappening)
    static let delete = String(localizationId: localizationIdDrop)

    enum Animation { case deleteDropArea }

    let title: String
    let isToday: Bool
    let eventId: String /// needed in a `CreateHappeningService`
    private var cells: [DayCellViewModel]
    var animation: Animation?
    var pickerDate: Date

    init(
        currentMoment: Date,
        startOfDay: Date,
        pickerDate: Date?,
        cells: [DayCellViewModel],
        eventId: String
    ) {
        self.title = Self.titleFormatter.string(from: startOfDay)
        self.isToday = DayIndex(currentMoment).date == startOfDay
        self.cells = cells
        self.animation = nil
        self.eventId = eventId
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
    }

    var identifiers: [String] { cells.map { $0.id } }
    func cell(for id: String) -> DayCellViewModel? {
        cells.first { $0.id == id }
    }

    mutating func enableDrag() { animation = .deleteDropArea }
    mutating func disableDrag() { animation = nil }
    mutating func handlePicker(date: Date) { pickerDate = date }

    private static let titleFormatter = {
        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = dayDetailsDateFormat
        return titleFormatter
    }()
}
