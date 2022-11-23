//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayViewModel {
    let date: Date
    var event: Event
    var shownHappenings: [Happening] { event.happenings(forDay: date) }

    init(date: Date, event: Event) {
        func updateTimeToCurrent(forDate: Date) -> Date {
            let c = Calendar.current
            let currentDate = Date.now
            let componentsWithCurrentTime = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
            var componentsToBeChanged = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: forDate)
            componentsToBeChanged.hour = componentsWithCurrentTime.hour
            componentsToBeChanged.minute = componentsWithCurrentTime.minute
            return c.date(from: componentsToBeChanged)!
        }

        self.date = updateTimeToCurrent(forDate: date)
        self.event = event
    }

    var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(for: date)
    }

    var count: Int { shownHappenings.count }

    func time(at: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happeningDate = shownHappenings[at].dateCreated
        return dateFormatter.string(from: happeningDate)
    }
}
