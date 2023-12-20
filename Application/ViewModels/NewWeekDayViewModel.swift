//
//  NewWeekCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

import Domain
import Foundation

struct NewWeekDayViewModel {
    let dayNumber: String
    let isToday: Bool

    init(event: Event, index: Int, today: Date) {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let cellDay = startOfWeek.adding(days: index)
        self.isToday = cellDay.date == today // make nice injection at Application Container
        self.dayNumber = String(cellDay.dayInMonth)
    }
}
