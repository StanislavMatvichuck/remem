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
    static let shownDaysForward = 14.0
    let today: DayComponents
    var event: Event
    var weekCellViewModels: [WeekCellViewModel]
    // MARK: - Init
    init(today: DayComponents, event: Event) {
        self.today = today
        self.event = event

        let dayInSeconds = 60 * 60 * 24.0
        let from = event.dateCreated.startOfWeek!
        let futureDays = dayInSeconds * Self.shownDaysForward
        let to = today.date.endOfWeek!.addingTimeInterval(futureDays)

        var viewModels = [WeekCellViewModel]()

        for date in stride(from: from, to: to, by: dayInSeconds) {
            let viewModel = WeekCellViewModel(
                day: DayComponents(date: date),
                today: today,
                happenings: []
            )
            viewModels.append(viewModel)
        }

        self.weekCellViewModels = viewModels
    }
}
