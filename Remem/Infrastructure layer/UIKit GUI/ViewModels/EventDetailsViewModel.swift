//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Foundation

class EventDetailsViewModel {
    typealias Model = Event
    typealias View = EventDetailsView

    var totalAmount: Int
    var dayAverage: Double
    var thisWeekTotal: Int
    var weekAverage: Double

    private var model: Model
    private weak var view: View?

    init(_ model: Model) {
        self.model = model

        let totalAmount: Int = {
            model.happenings.reduce(0) { partialResult, happening in
                partialResult + Int(happening.value)
            }
        }()

        var daysSince: Int {
            let cal = Calendar.current
            let fromDate = cal.startOfDay(for: model.dateCreated)
            let toDate = cal.startOfDay(for: Date())
            let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
            return numberOfDays + 1
        }

        var weeksSince: Int {
            var iterationDate = Date.now
            var result = 1

            while !iterationDate.isInSameWeek(as: model.dateCreated) {
                iterationDate = iterationDate.days(ago: 7)
                result += 1
            }

            return result
        }

        let dayAverage: Double = {
            let total = Double(totalAmount)
            let daysAmount = Double(daysSince)
            return total / daysAmount
        }()

        var weekAverage: Double {
            var weeksTotals: [Double] = []

            for i in 0 ... weeksSince - 1 {
                let totalAtWeek = Double(totalAtWeek(previousToCurrent: i))
                weeksTotals.append(totalAtWeek)
            }

            let total: Double = weeksTotals.reduce(0) { result, iterationAverage in
                result + iterationAverage
            }

            return total / Double(weeksTotals.count)
        }

        var thisWeekTotal: Int { totalAtWeek(previousToCurrent: 0) }
        var lastWeekTotal: Int { totalAtWeek(previousToCurrent: 1) }

        func totalAtWeek(previousToCurrent: Int) -> Int {
            var result = 0

            for happening in model.happenings {
                let weekOffset = Date.now.days(ago: 7 * previousToCurrent)
                if weekOffset.isInSameWeek(as: happening.dateCreated) {
                    result += Int(happening.value)
                }
            }

            return result
        }

        self.totalAmount = totalAmount
        self.dayAverage = dayAverage
        self.thisWeekTotal = thisWeekTotal
        self.weekAverage = weekAverage
    }
}

// MARK: - Public
extension EventDetailsViewModel {
    func configure(_ view: View) {
        self.view = view

        setStats()
    }
}

// MARK: - Private
extension EventDetailsViewModel {
    private func setStats() {
        view?.statsLabels[.total]?.text = "\(totalAmount)"
        view?.statsLabels[.average]?.text = "\(dayAverage)"
        view?.statsLabels[.weekAverage]?.text = "\(weekAverage)"
    }
}
