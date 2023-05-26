//
//  TimelineTesting.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Domain
import Foundation

protocol TimelineTesting {}

extension TimelineTesting {
    var value: String { "Hello" }
    var value02: String { "Byebye" }

    var dateTime: Date { Date(timeIntervalSinceReferenceDate: 0) }
    var anHourLater: Date { dateTime.addingTimeInterval(60 * 60) }
    var twelveHoursLater: Date { dateTime.addingTimeInterval(60 * 60 * 12) }
    var aDayLater: Date { dateTime.addingTimeInterval(60 * 60 * 24) }
    var twoDaysLater: Date { dateTime.addingTimeInterval(60 * 60 * 24 * 2) }
    var afterAWeek: Date { dateTime.addingTimeInterval(60 * 60 * 12 * 2 * 7) }
    var afterTwoWeeks: Date { dateTime.addingTimeInterval(60 * 60 * 12 * 2 * 7 * 2) }
    var afterThreeWeeks: Date { dateTime.addingTimeInterval(60 * 60 * 12 * 2 * 7 * 3) }
}

extension DayIndex {
    static var referenceValue: DayIndex { DayIndex(Date(timeIntervalSinceReferenceDate: 0)) }

    func adding(dateComponents: DateComponents) -> DayIndex {
        DayIndex(Calendar.current.date(byAdding: dateComponents, to: date)!)
    }
}
