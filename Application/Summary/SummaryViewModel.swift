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
    private let createdUntil: Date
    let items: [SummaryCellViewModel]

    init(event: Event, createdUntil: Date) {
        self.event = event
        self.createdUntil = createdUntil

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
            let startOfFirstWeek = WeekIndex(event.dateCreated).dayIndex
            let startOfLastWeek = WeekIndex(createdUntil).dayIndex
            let endOfLastWeek = startOfLastWeek.adding(days: 7)

            let calendar = Calendar.current
            let weeksDifference = calendar.dateComponents(
                [.weekOfYear],
                from: startOfFirstWeek.date,
                to: endOfLastWeek.date
            ).weekOfYear ?? 0

            let number = NSNumber(value: Double(totalAmount) / Double(weeksDifference))
            return averageNumberFormatter.string(from: number)!
        }()

        let daysTrackedAmount: Int = {
            let firstDay = DayIndex(event.dateCreated)
            let lastDay = DayIndex(createdUntil)

            let calendar = Calendar.current
            let daysDifference = calendar.dateComponents(
                [.day],
                from: firstDay.date,
                to: lastDay.date
            ).day ?? 0

            return daysDifference + 1
        }()

        let dayAverageAmount = {
            let total = Double(totalAmount)
            let daysAmount = Double(daysTrackedAmount)
            let number = NSNumber(value: total / daysAmount)
            return averageNumberFormatter.string(from: number)!
        }()

        let daysSinceLastHappeningAmount: String = {
            guard let lastHappeningDate = event.happenings.last?.dateCreated else { return "0" }
            let lastDay = DayIndex(createdUntil)

            let calendar = Calendar.current
            let daysDifference = calendar.dateComponents(
                [.day],
                from: lastHappeningDate,
                to: lastDay.date
            ).day ?? 0

            return String(daysDifference)
        }()

        self.items = [
            SummaryCellViewModel(SummaryRow.total(value: String(totalAmount))),
            SummaryCellViewModel(SummaryRow.daysSinceLastHappening(value: daysSinceLastHappeningAmount)),
            SummaryCellViewModel(SummaryRow.weekAverage(value: weekAverageAmount)),
            SummaryCellViewModel(SummaryRow.dayAverage(value: dayAverageAmount)),
            SummaryCellViewModel(SummaryRow.daysTracked(value: String(daysTrackedAmount)), belongsToUser: false)
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

    var valueTag: Int { labelTag + 1000 }
}

extension SummaryCellViewModel {
    init(_ row: SummaryRow, belongsToUser: Bool = true) {
        title = row.label
        value = row.value
        titleTag = row.labelTag
        valueTag = row.valueTag
        self.belongsToUser = belongsToUser
    }
}
