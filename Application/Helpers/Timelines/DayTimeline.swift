//
//  Timeline.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

struct DayTimeline<Element>: RandomAccessCollection {
    var storage: [Date: Element] = [:]
    
    var startIndex = DayIndex(Date.distantPast)
    var endIndex = DayIndex(Date.distantPast)
    
    subscript(i: DayIndex) -> Element? {
        get {
            return storage[i.date]
        }
        set {
            if isEmpty {
                startIndex = i
                endIndex = index(after: i)
            } else if i < startIndex {
                startIndex = i
            } else if i >= endIndex {
                endIndex = index(after: i)
            }
            
            storage[i.date] = newValue
        }
    }
    
    subscript(date: Date) -> Element? {
        get {
            return self[DayIndex(date)]
        }
        set {
            self[DayIndex(date)] = newValue
        }
    }
    
    subscript(i: Int) -> Element? { self[startIndex.adding(days: i)] }
    
    func index(after i: DayIndex) -> DayIndex {
        let nextDay = calendar.date(byAdding: DateComponents(day: 1), to: i.date)!
        return DayIndex(nextDay)
    }
    
    func index(before i: DayIndex) -> DayIndex {
        let previousDay = calendar.date(byAdding: DateComponents(day: -1), to: i.date)!
        return DayIndex(previousDay)
    }
    
    func distance(from start: DayIndex, to end: DayIndex) -> Int {
        return calendar.dateComponents([.day], from: start.date, to: end.date).day!
    }
    
    func index(_ i: DayIndex, offsetBy n: Int) -> DayIndex {
        let offsetDate = calendar.date(byAdding: DateComponents(day: n), to: i.date)!
        return DayIndex(offsetDate)
    }
}
