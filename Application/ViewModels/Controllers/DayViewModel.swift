//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation

struct DayViewModel {
    let create = String(localizationId: "button.create")
    let delete = String(localizationId: "button.delete")
    let cancel = String(localizationId: "button.cancel")
    let edit = String(localizationId: "button.edit")

    let day: DayComponents
    private let commander: EventsCommanding
    let event: Event

    let items: [String]
    var pickerDate: Date

    init(day: DayComponents, event: Event, commander: EventsCommanding) {
        self.event = event
        self.day = day
        self.commander = commander
        self.pickerDate = day.date

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

    func addHappening() {
        event.addHappening(date: pickerDate)
        commander.save(event)
    }

    func removeHappening(at: Int) {
        let happenings = event.happenings(forDayComponents: day)
        let removedHappening = happenings[at]
        do { try event.remove(happening: removedHappening) }
        catch { fatalError("unable to remove happening") }
        commander.save(event)
    }
}
