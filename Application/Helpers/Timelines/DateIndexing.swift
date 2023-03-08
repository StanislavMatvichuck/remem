//
//  DateIndexing.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.03.2023.
//

import Foundation

let calendar = Calendar.current

protocol DateIndexing: Comparable, CustomDebugStringConvertible {
    var date: Date { get }
}

// MARK: - Comparable
extension DateIndexing {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.date == rhs.date
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.date.compare(rhs.date) == .orderedAscending
    }
}

// MARK: - CustomDebugStringConvertible
extension DateIndexing {
    var debugDescription: String {
        let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateFormat = "MMMM d hh:mm"
            return f
        }()

        return dateFormatter.string(from: date)
    }
}
