//
//  StatsViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import Domain
import Foundation

struct SummaryViewModel {
    enum SummaryRow {
        case total(value: String)
        case weekAverage(value: String)
        case dayAverage(value: String)
        case daysTracked(value: String)
        case daysSinceLastHappening(value: String)

        var label: String {
            switch self {
            case .total: return String(localizationId: "summary.total")
            case .weekAverage: return String(localizationId: "summary.weekAverage")
            case .dayAverage: return String(localizationId: "summary.dayAverage")
            case .daysTracked: return String(localizationId: "summary.daysTracked")
            case .daysSinceLastHappening: return String(localizationId: "summary.daysSinceLastHappening")
            }
        }

        var value: String {
            switch self {
            case .total(let amount): return amount
            case .weekAverage(let amount): return amount
            case .dayAverage(let amount): return amount
            case .daysTracked(let amount): return amount
            case .daysSinceLastHappening(let amount): return amount
            }
        }

        var labelTag: Int {
            switch self {
            case .total: return 1
            case .weekAverage: return 2
            case .dayAverage: return 3
            case .daysTracked: return 4
            case .daysSinceLastHappening: return 5
            }
        }

        var valueTag: Int { self.labelTag + 1000 }
    }

    private let event: Event
    let items: [SummaryRow]

    init(event: Event, today: DayComponents) {
        self.event = event

        let totalAmount = String(
            event.happenings.reduce(0) { partialResult, happening in
                partialResult + Int(happening.value)
            }
        )

        let weekAverageAmount: String = {
            "0"
        }()

        let daysTrackedAmount: Int = {
            let cal = Calendar.current
            let fromDate = cal.startOfDay(for: event.dateCreated)
            let toDate = cal.startOfDay(for: Date())
            let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
            return numberOfDays + 1
        }()

        let dayAverageAmount = {
            let formatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 2
                return formatter
            }()

            let total = Double(totalAmount)!
            let daysAmount = Double(daysTrackedAmount)
            let number = NSNumber(value: total / daysAmount)
            return formatter.string(from: number)!
        }()

        let daysSinceLastHappeningAmount: String = {
            let cal = Calendar.current
            let fromDate = cal.startOfDay(for: event.happenings.last?.dateCreated ?? today.date)
            let toDate = cal.startOfDay(for: today.date)
            let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
            return String(numberOfDays)
        }()

        self.items = [
            SummaryRow.total(value: totalAmount),
            SummaryRow.weekAverage(value: weekAverageAmount),
            SummaryRow.dayAverage(value: dayAverageAmount),
            SummaryRow.daysTracked(value: String(daysTrackedAmount)),
            SummaryRow.daysSinceLastHappening(value: daysSinceLastHappeningAmount)
        ]
    }
}
