//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Domain
import Foundation

struct WeekItemViewModel {
    private let event: Event
    private let day: DayComponents
    private let today: DayComponents
    private let coordinator: DefaultCoordinator

    let isToday: Bool
    let amount: String
    let items: [String]
    let dayNumber: String
    let date: Date /// used only by `WeekViewControllerTests`

    init(
        event: Event,
        day: DayComponents,
        today: DayComponents,
        coordinator: DefaultCoordinator
    ) {
        self.day = day
        self.today = today
        self.event = event
        self.coordinator = coordinator

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        self.items = event.happenings(forDayComponents: day).map { happening in
            formatter.string(from: happening.dateCreated)
        }

        self.dayNumber = String(day.value.day ?? 0)
        self.amount = String(items.count)
        self.isToday = day == today
        self.date = day.date
    }

    // TODO: test this method
    func select() {
        coordinator.show(.dayDetails(day: day, event: event))
    }
}
