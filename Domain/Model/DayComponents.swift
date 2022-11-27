//
//  DayComponents.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 27.11.2022.
//

import Foundation

public struct DayComponents: Equatable, CustomDebugStringConvertible {
    public let date: Date
    public let value: DateComponents

    public init(date: Date) {
        self.date = date
        value = Calendar.current.dateComponents([.year, .month, .day], from: date)
    }

    public var debugDescription: String { "\(date.debugDescription) \(value.debugDescription)" }

    public static func == (lhs: DayComponents, rhs: DayComponents) -> Bool {
        return lhs.value == rhs.value
    }

    public static let referenceValue: DayComponents = {
        let referenceDay = DateComponents(year: 2001, month: 1, day: 1)
        let referenceDate = Calendar.current.date(from: referenceDay)!
        let day = DayComponents(date: referenceDate)
        return day
    }()

    public func adding(components: DateComponents) -> DayComponents {
        DayComponents(date: Calendar.current.date(byAdding: components, to: date)!)
    }
}
