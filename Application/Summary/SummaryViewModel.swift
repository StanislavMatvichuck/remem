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
            SummaryCellViewModel(SummaryRow.total, value: String(totalAmount)),
            SummaryCellViewModel(SummaryRow.daysTracked, value: String(daysTrackedAmount)),
            SummaryCellViewModel(SummaryRow.dayAverage, value: dayAverageAmount),
            SummaryCellViewModel(SummaryRow.weekAverage, value: weekAverageAmount)
        ]
    }

    var identifiers: [SummaryRow] { items.map { $0.id }}

    func cell(for id: SummaryRow) -> SummaryCellViewModel? {
        items.first { $0.id == id }
    }
}

enum SummaryRow: CaseIterable {
    case total, daysTracked, dayAverage, weekAverage, daysSinceLastHappening

    var title: String { switch self {
    case .total: return String(localizationId: "summary.total") + "\n"
    case .weekAverage: return String(localizationId: "summary.weekAverage") + "\n"
    case .dayAverage: return String(localizationId: "summary.dayAverage") + "\n"
    case .daysTracked: return String(localizationId: "summary.daysTracked") + "\n"
    case .daysSinceLastHappening: return String(localizationId: "summary.daysSinceLastHappening") + "\n"
    } }

    var id: String { switch self {
    case .total: return "total"
    case .weekAverage: return "weekAverage"
    case .dayAverage: return "dayAverage"
    case .daysTracked: return "daysTracked"
    case .daysSinceLastHappening: return "daysSinceLastHappening"
    } }
}

extension SummaryCellViewModel {
    init(_ row: SummaryRow, value: String) {
        id = row
        title = row.title
        self.value = value
    }
}
