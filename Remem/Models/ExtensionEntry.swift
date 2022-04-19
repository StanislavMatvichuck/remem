//
//  ExtensionEntry.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import CoreData
import Foundation

// MARK: - Getters
extension Entry {
    var totalAmount: Int {
        guard let points = self.points else { return 0 }
        return points.reduce(0) { partialResult, point in
            let point = point as! Point
            return partialResult + Int(point.value)
        }
    }

    var daysSince: Int {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: dateCreated!)
        let toDate = cal.startOfDay(for: Date())
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate).day!
        return numberOfDays + 1
    }

    var weeksSince: Int {
        var iterationDate = Date.now
        var result = 1

        while !iterationDate.isInSameWeek(as: dateCreated!) {
            iterationDate = iterationDate.days(ago: 7)
            result += 1
        }

        return result
    }

    var dayAverage: Double {
        let total = Double(totalAmount)
        let daysAmount = Double(daysSince)
        return total / daysAmount
    }

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

    private func totalAtWeek(previousToCurrent: Int) -> Int {
        guard let points = self.points else { return 0 }

        var result = 0
        for point in points {
            guard let point = point as? Point else { continue }
            let weekOffset = Date.now.days(ago: 7 * previousToCurrent)
            if weekOffset.isInSameWeek(as: point.dateCreated!) {
                result += Int(point.value)
            }
        }

        return result
    }
}

// MARK: - Public
extension Entry {
    @discardableResult
    open func addDefaultPoint() -> Point? {
        guard let moc = managedObjectContext else { return nil }

        let point = Point(context: moc)
        point.dateCreated = Date()
        point.entry = self
        point.value = 1

        return point
    }

    @discardableResult
    open func addDefaultPoint(withDate: Date) -> Point? {
        guard let moc = managedObjectContext else { return nil }

        let point = Point(context: moc)
        point.dateCreated = withDate
        point.entry = self
        point.value = 1

        return point
    }
}
