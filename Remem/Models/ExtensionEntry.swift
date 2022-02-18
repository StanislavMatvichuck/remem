//
//  ExtensionEntry.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import Foundation

extension Entry {
    var totalAmount: Int {
        guard let points = self.points else { return 0 }

        return points.reduce(0) { partialResult, point in
            if let point = point as? Point {
                return partialResult + Int(point.value)
            } else {
                return partialResult
            }
        }
    }

    var dayAverage: Float {
        guard let points = self.points else { return 0 }

        var results = [DateComponents: Int]()

        for point in points {
            guard let point = point as? Point else { continue }

            let pointDay = Calendar.current.dateComponents([.year, .month, .day], from: point.dateCreated!)

            if let daySum = results[pointDay] {
                results.updateValue(daySum + 1, forKey: pointDay)
            } else {
                results.updateValue(1, forKey: pointDay)
            }
        }

        var totalAmount = 0

        for daySum in results {
            totalAmount += daySum.value
        }

        if results.count == 0 {
            return 0
        }

        return Float(totalAmount) / Float(results.count)
    }

    var weekAverage: Float {
        guard let points = self.points else { return 0 }

        var results = [DateComponents: Int]()

        for point in points {
            guard let point = point as? Point else { continue }

            let pointWeek = Calendar.current.dateComponents([.year, .weekOfYear], from: point.dateCreated!)

            if let daySum = results[pointWeek] {
                results.updateValue(daySum + 1, forKey: pointWeek)
            } else {
                results.updateValue(1, forKey: pointWeek)
            }
        }

        var totalAmount = 0

        for daySum in results {
            totalAmount += daySum.value
        }

        if results.count == 0 {
            return 0
        }

        return Float(totalAmount) / Float(results.count)
    }

    var lastWeekTotal: Int {
        guard let points = self.points else { return 0 }

        var result = 0

        for point in points {
            guard let point = point as? Point else { continue }

            let previousWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!

            if previousWeek.isInSameWeek(as: point.dateCreated!) {
                result += 1
            }
        }

        return result
    }

    var thisWeekTotal: Int {
        guard let points = self.points else { return 0 }

        var result = 0

        for point in points {
            guard let point = point as? Point else { continue }

            if Date.now.isInSameWeek(as: point.dateCreated!) {
                result += 1
            }
        }

        return result
    }
}
