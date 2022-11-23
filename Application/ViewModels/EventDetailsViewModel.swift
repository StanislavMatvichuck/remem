//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation

struct EventDetailsViewModel {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    let event: Event

    init(event: Event) { self.event = event }

    var totalAmount: String {
        String(event.happenings.reduce(0) { partialResult, happening in
            partialResult + Int(happening.value)
        })
    }

    var dayAverage: String {
        let total = Double(totalAmount)
        let daysAmount = Double(daysSince)
        let number = NSNumber(value: total! / daysAmount)
        return formatter.string(from: number)!
    }

    var daysSince: Int {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: event.dateCreated)
        let toDate = cal.startOfDay(for: Date())
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
        return numberOfDays + 1
    }
}
