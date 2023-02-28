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
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 1
    }
}

struct WeekItemViewModel {
    private let event: Event
    private let day: DayIndex
    private let today: DayIndex
    private let tapHandler: () -> ()

    let isToday: Bool
    let amount: String
    let items: [String]
    let dayNumber: String
    let date: Date /// used only by `WeekViewControllerTests`

    init(
        event: Event,
        day: DayIndex,
        today: DayIndex,
        tapHandler: @escaping () -> ()
    ) {
        self.day = day
        self.today = today
        self.event = event
        self.tapHandler = tapHandler

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.items = event.happenings(forDayIndex: day).map { happening in
            formatter.string(from: happening.dateCreated)
        }

        self.dayNumber = String(day.dayInMonth)
        self.amount = String(items.count)
        self.isToday = day == today
        self.date = day.date
    }

    func select() { tapHandler() }
}
