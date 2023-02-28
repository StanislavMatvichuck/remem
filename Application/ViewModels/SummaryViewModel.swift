//
//  StatsViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import Domain
import Foundation

struct SummaryViewModel {
    private let event: Event
    private let itemFactory: SummaryItemViewModelFactoring
    let items: [SummaryItemViewModel]

    init(
        event: Event,
        today: DayIndex,
        itemFactory: SummaryItemViewModelFactoring)
    {
        self.event = event
        self.itemFactory = itemFactory

        let averageNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            return formatter
        }()

        let totalAmount = event.happenings.reduce(0) { partialResult, happening in
            partialResult + Int(happening.value)
        }

        let weekAverageAmount: String = {
            var timeline = WeekTimeline<Bool>()
            timeline[WeekIndex(event.dateCreated)] = true
            timeline[WeekIndex(today.date)] = true
            let weeksAmount = timeline.count
            let number = NSNumber(value: Double(totalAmount) / Double(weeksAmount))
            return averageNumberFormatter.string(from: number)!
        }()

        let daysTrackedAmount: Int = {
            var timeline = DayTimeline<Bool>()
            timeline[DayIndex(event.dateCreated)] = true
            timeline[today] = true
            return timeline.count
        }()

        let dayAverageAmount = {
            let total = Double(totalAmount)
            let daysAmount = Double(daysTrackedAmount)
            let number = NSNumber(value: total / daysAmount)
            return averageNumberFormatter.string(from: number)!
        }()

        let daysSinceLastHappeningAmount: String = {
            guard let lastHappeningDate = event.happenings.last?.dateCreated else { return "0" }

            var timeline = DayTimeline<Bool>()
            timeline[DayIndex(lastHappeningDate)] = true
            timeline[today] = true

            return String(timeline.count - 1)
        }()

        self.items = [
            itemFactory.make(SummaryRow.total(value: String(totalAmount))),
            itemFactory.make(SummaryRow.weekAverage(value: weekAverageAmount)),
            itemFactory.make(SummaryRow.dayAverage(value: dayAverageAmount)),
            itemFactory.make(SummaryRow.daysTracked(value: String(daysTrackedAmount))),
            itemFactory.make(SummaryRow.daysSinceLastHappening(value: daysSinceLastHappeningAmount))
        ]
    }
}

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
