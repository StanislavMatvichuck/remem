//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayDetailsViewModel {
    let day: DayComponents
    let items: [String]

    init(day: DayComponents, event: Event) {
        self.day = day

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happenings = event.happenings(forDayComponents: day)
        self.items = happenings.map { dateFormatter.string(from: $0.dateCreated) }
    }

    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(for: day.date)
    }
}
