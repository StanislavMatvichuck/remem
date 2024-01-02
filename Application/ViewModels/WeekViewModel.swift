//
//  WeekViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2023.
//

import Domain
import Foundation

struct WeekViewModel {
    private let event: Event
    private let pageFactory: WeekPageViewModelFactoring
    private let createUntil: Date

    let dayMaximum: Int
    let pagesCount: Int

    init(
        event: Event,
        pageFactory: WeekPageViewModelFactoring,
        createUntil: Date
    ) {
        let pagesCount = {
            let startOfFirstWeek = WeekIndex(event.dateCreated).dayIndex
            let startOfLastWeek = WeekIndex(createUntil).dayIndex
            let endOfLastWeek = startOfLastWeek.adding(days: 7)

            let calendar = Calendar.current
            let weeksDifference = calendar.dateComponents(
                [.weekOfYear],
                from: startOfFirstWeek.date,
                to: endOfLastWeek.date
            ).weekOfYear ?? 0
            return weeksDifference
        }()

        self.event = event
        self.pageFactory = pageFactory
        self.createUntil = createUntil
        self.pagesCount = pagesCount
        self.dayMaximum = {
            let daysAmount = pagesCount * 7

            var maximum = 0
            for dayNumber in 0 ..< daysAmount - 1 {
                let startOfWeekEvent = WeekIndex(event.dateCreated).dayIndex
                let dayHappenings = event.happenings(forDayIndex: startOfWeekEvent.adding(days: dayNumber)).count
                if dayHappenings > maximum { maximum = dayHappenings }
            }

            return maximum
        }()
    }

    func page(at index: Int) -> WeekPageViewModel {
        pageFactory.makeWeekPageViewModel(pageIndex: index, dailyMaximum: dayMaximum)
    }
}
