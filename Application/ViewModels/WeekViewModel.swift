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
    static let shownDaysForward = 14
    var event: Event
    var weekCellViewModels: [WeekCellViewModel]
    // MARK: - Init
    init(event: Event) {
        self.event = event
        self.weekCellViewModels = Self.makeWeekCellViewModels(event: event)
    }

    var count: Int { weekCellViewModels.count }
    func cellViewModel(at index: Int) -> WeekCellViewModel? {
        guard index < weekCellViewModels.count, index >= 0 else { return nil }
        let date = weekCellViewModels[index].date
        let viewModel = WeekCellViewModel(date: date, event: event)
        return viewModel
    }

    private static func makeWeekCellViewModels(event: Event) -> [WeekCellViewModel] {
        let from = event.dateCreated.startOfWeek!
        let futureDays = Double(60*60*24*Self.shownDaysForward)
        let to = Date.now.endOfWeek!.addingTimeInterval(futureDays)

        let dayDurationInSeconds: TimeInterval = 60*60*24
        var viewModels = [WeekCellViewModel]()

        for date in stride(from: from, to: to, by: dayDurationInSeconds) {
            var endOfTheDayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            endOfTheDayComponents.hour = 23
            endOfTheDayComponents.minute = 59
            endOfTheDayComponents.second = 59

            guard let endOfTheDayDate = Calendar.current.date(from: endOfTheDayComponents) else { continue }
            let viewModel = WeekCellViewModel(date: endOfTheDayDate, event: event)
            viewModels.append(viewModel)
        }

        return viewModels
    }
}
