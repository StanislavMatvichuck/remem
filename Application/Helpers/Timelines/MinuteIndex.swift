//
//  MinuteIndex.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.03.2023.
//

import Foundation

struct MinuteIndex: DateIndexing {
    public let date: Date

    public init(_ date: Date) {
        let minuteComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        self.date = calendar.date(from: minuteComponents)!
    }
}
