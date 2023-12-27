//
//  NewWeekViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2023.
//

import Domain
import Foundation

struct NewWeekViewModel {
    private let event: Event
    private let pageFactory: NewWeekPageViewModelFactoring
    private let today: Date

    init(event: Event, pageFactory: NewWeekPageViewModelFactoring, today: Date) {
        self.event = event
        self.pageFactory = pageFactory
        self.today = today
    }

    var pagesCount: Int {
        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
        let startOfWeekToday = WeekIndex(today).dayIndex
        let endOfWeekToday = startOfWeekToday.adding(days: 7)

        let calendar = Calendar.current
        let weeksDifference = calendar.dateComponents(
            [.year, .weekOfYear],
            from: startOfWeek.date,
            to: endOfWeekToday.date
        ).weekOfYear ?? 0
        return weeksDifference
    }

    func page(at index: Int) -> NewWeekPageViewModel {
        pageFactory.makeNewWeekPageViewModel(pageIndex: index)
    }
}
