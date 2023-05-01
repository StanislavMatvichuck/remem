//
//  Timeline.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

public struct DayTimeline<Element>: RandomAccessCollection {
    private var storage: [Date: Element] = [:]
    private var calendar: Calendar { .current }
    
    public var startIndex = DayIndex(Date.distantPast)
    public var endIndex = DayIndex(Date.distantPast)
    
    public init(storage: [Date : Element] = [:], startIndex: DayIndex = DayIndex(Date.distantPast), endIndex: DayIndex = DayIndex(Date.distantPast)) {
        self.storage = storage
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    public subscript(i: DayIndex) -> Element? {
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
    
    public subscript(date: Date) -> Element? {
        get {
            return self[DayIndex(date)]
        }
        set {
            self[DayIndex(date)] = newValue
        }
    }
    
    public subscript(i: Int) -> Element? { self[startIndex.adding(days: i)] }
    
    public func index(after i: DayIndex) -> DayIndex {
        let nextDay = calendar.date(byAdding: DateComponents(day: 1), to: i.date)!
        return DayIndex(nextDay)
    }
    
    public func index(before i: DayIndex) -> DayIndex {
        let previousDay = calendar.date(byAdding: DateComponents(day: -1), to: i.date)!
        return DayIndex(previousDay)
    }
    
    public func distance(from start: DayIndex, to end: DayIndex) -> Int {
        return calendar.dateComponents([.day], from: start.date, to: end.date).day!
    }
    
    public func index(_ i: DayIndex, offsetBy n: Int) -> DayIndex {
        let offsetDate = calendar.date(byAdding: DateComponents(day: n), to: i.date)!
        return DayIndex(offsetDate)
    }
}
