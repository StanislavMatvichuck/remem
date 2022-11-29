//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation
import IosUseCases

struct WeekViewModel {
    private let upcomingWeeksCount = 3
    let today: DayComponents
    var event: Event
    var weekCellViewModels: [WeekCellViewModel]
    // MARK: - Init
    init(today: DayComponents, event: Event) {
        self.today = today
        self.event = event

        var startOfWeekAfterEventCreation = DayComponents(date: event.dateCreated).value
        startOfWeekAfterEventCreation.weekday = 2 /// set Monday
        let startOfWeekDate = Calendar.current.date(from: startOfWeekAfterEventCreation)
        let startOfWeekDay = DayComponents(date: startOfWeekDate!)

        var viewModels = [WeekCellViewModel]()

        for addedDay in 0 ..< upcomingWeeksCount * 7 {
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
