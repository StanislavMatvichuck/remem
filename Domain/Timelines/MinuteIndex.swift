//
//  MinuteIndex.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.03.2023.
//

import Foundation

public struct MinuteIndex: DateIndexing {
    public let date: Date

    public init(_ date: Date) {
        let minuteComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        self.date = Calendar.current.date(from: minuteComponents)!
    }
}
