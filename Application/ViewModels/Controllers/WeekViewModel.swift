//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation

struct WeekViewModel {
    private let upcomingWeeksCount = 3
    let today: DayComponents
    var event: Event
    var items: [WeekItemViewModel]
    var scrollToIndex: Int = 0
    // MARK: - Init
    init(today: DayComponents, event: Event) {
        self.today = today
        self.event = event

        let startOfWeekDayCreated = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: event.dateCreated
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayComponents(date: date)
        }()

        let startOfWeekDayToday = {
            let cal = Calendar.current
            let startOfWeekDateComponents = cal.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: today.date
            )
            let date = cal.date(from: startOfWeekDateComponents)!
            return DayComponents(date: date)
        }()

        let weeksBetweenTodayAndEventCreationDay: Int = {
            let amount = Calendar.current.dateComponents(
                [.weekOfYear],
                from: event.dateCreated,
                to: today.date
            ).weekOfYear ?? 0
            return max(0, amount)
        }()

        let daysToShow = (weeksBetweenTodayAndEventCreationDay + upcomingWeeksCount) * 7

        var viewModels = [WeekItemViewModel]()
        for addedDay in 0 ..< daysToShow {
            let cellDay = startOfWeekDayCreated.adding(components: DateComponents(day: addedDay))
            let vm = WeekItemViewModel(
                day: cellDay,
                today: today,
                happenings: event.happenings(forDayComponents: cellDay)
            )

            viewModels.append(vm)

            if vm.isToday {
                let index = viewModels.firstIndex(where: { $0.day == startOfWeekDayToday })
                scrollToIndex = index ?? 0
            }
        }

        items = viewModels
    }
}
