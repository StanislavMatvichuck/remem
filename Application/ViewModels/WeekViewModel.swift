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
    var weekCellViewModels: [WeekCellViewModel]
    // MARK: - Init
    init(today: DayComponents, event: Event) {
        self.today = today
        self.event = event

        let startOfWeekDay = {
            var startOfWeekAfterEventCreation = DayComponents(date: event.dateCreated).value
            startOfWeekAfterEventCreation.weekday = 2 /// set Monday
            let startOfWeekDate = Calendar.current.date(from: startOfWeekAfterEventCreation)!
            return DayComponents(date: startOfWeekDate)
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

        var viewModels = [WeekCellViewModel]()
        for addedDay in 0 ..< daysToShow {
            let cellDay = startOfWeekDay.adding(components: DateComponents(day: addedDay))
            viewModels.append(WeekCellViewModel(
                day: cellDay,
                today: today,
                happenings: event.happenings(forDayComponents: cellDay)
            ))
        }

        self.weekCellViewModels = viewModels
    }
}
