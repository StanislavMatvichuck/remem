//
//  StatsViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import Domain

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

    init(event: Event) {
        self.event = event

        let totalAmount = String(
            event.happenings.reduce(0) { partialResult, happening in
                partialResult + Int(happening.value)
            }
        )

        let weekAverageAmount = "0"
        let dayAverageAmount = "0"
        let daysTrackedAmount = "1"
        let daysSinceLastHappeningAmount = "0"

        self.items = [
            SummaryRow.total(value: totalAmount),
            SummaryRow.weekAverage(value: weekAverageAmount),
            SummaryRow.dayAverage(value: dayAverageAmount),
            SummaryRow.daysTracked(value: daysTrackedAmount),
            SummaryRow.daysSinceLastHappening(value: daysSinceLastHappeningAmount)
        ]
    }
}
