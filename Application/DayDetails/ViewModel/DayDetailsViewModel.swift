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
    let eventId: String /// used in a `CreateHappeningService`

    var animation: Animation?
    var pickerDate: Date

    private let eventsReader: EventsReading
    private var cells: [DayCellViewModel]

    init(
        currentMoment: Date,
        startOfDay: Date,
        pickerDate: Date?,
        eventsReader: EventsReading,
        eventId: String
    ) {
        self.eventsReader = eventsReader
        self.title = Self.titleFormatter.string(from: startOfDay)
        self.isToday = DayIndex(currentMoment).date == startOfDay
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

        self.cells = eventsReader
            .read(byId: eventId)
            .happenings(forDayIndex: DayIndex(startOfDay))
            .map { DayCellViewModel(id: UUID(), happening: $0) }
    }

    var identifiers: [UUID] { cells.map { $0.id }}
    func cell(for id: UUID) -> DayCellViewModel? { cells.first { $0.id == id } }

    mutating func enableDrag() { animation = .deleteDropArea }
    mutating func disableDrag() { animation = nil }
    mutating func handlePicker(date: Date) { pickerDate = date }

    private static let titleFormatter = {
        let titleFormatter = DateFormatter()
        titleFormatter.dateFormat = dayDetailsDateFormat
        return titleFormatter
    }()
}

/// Used to mutate list without refetching everything from controller
/// they are used by `DayDetailsController` as a reaction to `DomainEvents`
extension DayDetailsViewModel {
    mutating func add(happening: Happening) {
        let createdCell = DayCellViewModel(id: UUID(), happening: happening)

        /// This insertion logic duplicates Event.addHappening method
        if let insertIndex = cells.lastIndex(where: { $0.happening.dateCreated <= createdCell.happening.dateCreated }) {
            cells.insert(createdCell, at: insertIndex + 1)
        } else {
            cells.insert(createdCell, at: 0)
        }
    }

    mutating func remove(cell: DayCellViewModel) {
        if let index = cells.firstIndex(where: { $0.id == cell.id }) {
            cells.remove(at: index)
        }
    }
}
