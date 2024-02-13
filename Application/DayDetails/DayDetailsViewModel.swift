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
    static let delete = String(localizationId: "dropToDelete")

    typealias AddHappeningHandler = (Date) -> Void

    enum Animation { case deleteDropArea }

    let title: String
    let isToday: Bool
    var cells: [DayCellViewModel]
    var animation: Animation?
    var pickerDate: Date

    private let addHappeningHandler: AddHappeningHandler

    init(
        currentMoment: Date,
        startOfDay: Date,
        pickerDate: Date?,
        cells: [DayCellViewModel],
        addHappeningHandler: @escaping AddHappeningHandler
    ) {
        self.title = Self.titleFormatter.string(from: startOfDay)
        self.isToday = DayIndex(currentMoment).date == startOfDay
        self.cells = cells
        self.animation = nil
        self.addHappeningHandler = addHappeningHandler
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

    func addHappening() { addHappeningHandler(pickerDate) }
    mutating func enableDrag() { animation = .deleteDropArea }
    mutating func disableDrag() { animation = nil }
    mutating func handlePicker(date: Date) { pickerDate = date }

    mutating func configureCellsAnimations(_ oldValue: DayDetailsViewModel?) {
        guard let oldValue else { return }
        cells = cells.map { cell in
            var updatedCell = cell
            updatedCell.animation = .new

            for oldCell in oldValue.cells {
                if cell == oldCell { updatedCell.animation = nil }
            }

            return updatedCell
        }
    }

    private static let titleFormatter = {
        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = "d MMMM"
        return titleFormatter
    }()
}
