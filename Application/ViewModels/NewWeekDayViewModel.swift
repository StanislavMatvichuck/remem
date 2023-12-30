//
//  NewWeekCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

struct NewWeekDayViewModel {
    typealias TapHandler = (@escaping AnimationBlock, @escaping AnimationBlock) -> ()
    typealias AnimationBlock = () -> ()

    let dayNumber: String
    let dayName: String
    let isToday: Bool
    let isDimmed: Bool
    let hasHappenings: Bool
    let happeningsAmount: String
    let relativeLength: CGFloat
    let tapHandler: TapHandler

    init(
        event: Event,
        index: Int,
        today: Date,
        weekMaximum: Int,
        tapHandler: @escaping TapHandler = { _, _ in }
    ) {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let day = startOfWeek.adding(days: index)
        let dayDate = day.date

        self.isToday = dayDate == today
        self.dayNumber = String(day.dayInMonth)
        self.dayName = dayDate.formatted(Date.FormatStyle().weekday(.narrow))

        let dayBeforeEventIsCreated = day < DayIndex(event.dateCreated)
        let dayAfterToday = dayDate > today
        self.isDimmed = dayBeforeEventIsCreated || dayAfterToday

        let happeningsAmount = event.happenings(forDayIndex: day).count
        self.happeningsAmount = "\(happeningsAmount)"
        self.hasHappenings = happeningsAmount > 0

        let relativeLength = CGFloat(happeningsAmount) / CGFloat(weekMaximum)
        self.relativeLength = weekMaximum == 0 ? 0 : relativeLength

        self.tapHandler = tapHandler
    }
}
