//
//  WeekCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

struct WeekDayViewModel {
    let dayNumber: String
    let dayName: String
    let isToday: Bool
    let isDimmed: Bool
    let hasHappenings: Bool
    let happeningsAmount: String
    let relativeLength: CGFloat
    // these properties only passed to a service
    let eventId: String
    let startOfDay: Date

    init(
        event: Event,
        index: Int,
        today: Date,
        dailyMaximum: Int
    ) {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let day = startOfWeek.adding(days: index)
        let dayDate = day.date

        self.eventId = event.id
        self.startOfDay = dayDate
        self.isToday = day == DayIndex(today)
        self.dayNumber = String(day.dayInMonth)
        self.dayName = dayDate.formatted(Date.FormatStyle().weekday(.narrow))

        let dayBeforeEventIsCreated = day < DayIndex(event.dateCreated)
        let dayAfterToday = dayDate > today
        self.isDimmed = dayBeforeEventIsCreated || dayAfterToday

        let happeningsAmount = event.happenings(forDayIndex: day).count
        self.happeningsAmount = "\(happeningsAmount)"
        self.hasHappenings = happeningsAmount > 0

        let relativeLength = CGFloat(happeningsAmount) / CGFloat(dailyMaximum)
        self.relativeLength = dailyMaximum == 0 ? 0 : relativeLength
    }
}

extension DayIndex {
    var dayInMonth: Int {
        let components = Calendar.current.dateComponents([.day], from: date)
        return components.day ?? 1
    }
}
