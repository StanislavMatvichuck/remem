//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation

struct EventViewModel {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private let event: Event
    private let commander: EventsCommanding

    init(
        event: Event,
        commander: EventsCommanding
    ) {
        self.event = event
        self.commander = commander
    }

    var title: String { event.name }
    var isVisited: Bool { event.dateVisited != nil }

    func visit() {
        event.visit()
        commander.save(event)
    }

    /// deprecated. move to `StatsViewModel`
    var totalAmount: String {
        String(event.happenings.reduce(0) { partialResult, happening in
            partialResult + Int(happening.value)
        })
    }

    /// deprecated. move to `StatsViewModel`
    var dayAverage: String {
        let total = Double(totalAmount)
        let daysAmount = Double(daysSince)
        let number = NSNumber(value: total! / daysAmount)
        return formatter.string(from: number)!
    }

    /// deprecated. move to `StatsViewModel`
    var daysSince: Int {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: event.dateCreated)
        let toDate = cal.startOfDay(for: Date())
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
        return numberOfDays + 1
    }
}
