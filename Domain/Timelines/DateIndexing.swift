//
//  DateIndexing.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.03.2023.
//

import Foundation

public protocol DateIndexing: Comparable {
    var date: Date { get }
}

public extension DateIndexing {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.date == rhs.date
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.date.compare(rhs.date) == .orderedAscending
    }
}
