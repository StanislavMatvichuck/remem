//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Domain
import Foundation
import IosUseCases

struct WeekCellViewModel {
    let day: DayComponents
    let today: DayComponents
    let happenings: [Happening]

    init(day: DayComponents, today: DayComponents, happenings: [Happening]) {
        self.day = day
        self.today = today
        self.happenings = happenings
    }

    var dayNumber: String { String(day.value.day ?? 0) }
    var amount: String { String(happenings.count) }
    var isToday: Bool { day == today }

    var happeningsTimings: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return happenings.map { happening in
            formatter.string(from: happening.dateCreated)
        }
    }
}
