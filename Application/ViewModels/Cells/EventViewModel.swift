//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventViewModel {
    let event: Event
    let today: DayComponents

    // MARK: - Init
    init(event: Event, today: DayComponents) {
        self.event = event
        self.today = today
    }

    var name: String { event.name }

    var amount: String {
        let todayDate = Date.now
        let todayHappeningsCount = event.happenings(forDay: todayDate).count
        return String(todayHappeningsCount)
    }
}
