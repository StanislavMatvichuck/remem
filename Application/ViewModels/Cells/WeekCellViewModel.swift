//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Domain
import Foundation

extension DayIndex {
    var dayInMonth: Int {
        let components = Calendar.current.dateComponents([.day], from: date)
        return components.day ?? 1
    }
}

struct WeekCellViewModel {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    typealias TapHandler = () -> Void

    let isToday: Bool
    let amount: String
    let items: [String]
    let dayNumber: String
    let highlighted: Bool
    let date: Date /// used only by `WeekViewControllerTests`
    let tapHandler: TapHandler

    private let event: Event
    private let day: DayIndex
    private let today: DayIndex

    init(
        event: Event,
        day: DayIndex,
        today: DayIndex,
        tapHandler: @escaping TapHandler
    ) {
        self.day = day
        self.today = today
        self.event = event
        self.tapHandler = tapHandler

        self.items = event.happenings(forDayIndex: day).map { happening in
            Self.formatter.string(from: happening.dateCreated)
        }

        let dayCreated = DayIndex(event.dateCreated)
        self.highlighted = day >= dayCreated && day <= today
        self.dayNumber = String(day.dayInMonth)
        self.amount = String(items.count)
        self.isToday = day == today
        self.date = day.date
    }
}

protocol WeekItemViewModelFactoring {
    func makeViewModel(day: DayIndex) -> WeekCellViewModel
}
