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
            [.weekOfYear],
            from: startOfWeek.date,
            to: endOfWeekToday.date
        ).weekOfYear ?? 0
        return weeksDifference
    }

    func page(at index: Int) -> NewWeekPageViewModel {
        pageFactory.makeNewWeekPageViewModel(index: index)
    }

//    /// Days visible amount
//    /// - Parameter today: first visible day
//    /// - Returns: amount that is divided by seven
//    func daysCount(forToday today: Date) -> Int {
//        let startOfWeek = WeekIndex(event.dateCreated).dayIndex
//        let startOfWeekToday = WeekIndex(today).dayIndex
//        let endOfWeekToday = startOfWeekToday.adding(days: 7)
//
//        let calendar = Calendar.current
//        let daysDifference = calendar.dateComponents([.day], from: startOfWeek.date, to: endOfWeekToday.date).day ?? 0
//
//        return daysDifference
//    }
//
//    /// Used by UICollectionView in NewWeekView
//    /// - Parameter index: days distance from start of the week of event creation
//    /// - Returns: cell that describe day of the week
//    func day(at index: IndexPath) -> NewWeekDayViewModel? {
//        dayFactory.makeNewWeekDayViewModel(index: index.row)
//    }
}
