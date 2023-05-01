//
//  WeekTimeline.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

public struct WeekTimeline<Element>: RandomAccessCollection {
    private var storage: [Date: Element] = [:]
    private var calendar: Calendar { .current }
    
    public var startIndex = WeekIndex(Date.distantPast)
    public var endIndex = WeekIndex(Date.distantPast)
    
    public init(storage: [Date : Element] = [:], startIndex: WeekIndex = WeekIndex(Date.distantPast), endIndex: WeekIndex = WeekIndex(Date.distantPast)) {
        self.storage = storage
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    public subscript(i: WeekIndex) -> Element? {
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
            return self[WeekIndex(date)]
        }
        set {
            self[WeekIndex(date)] = newValue
        }
    }
    
    public subscript(i: Int) -> Element? { self[WeekIndex(calendar.date(byAdding: DateComponents(day: i * 7), to: startIndex.date)!)] }
    
    public func index(after i: WeekIndex) -> WeekIndex {
        let nextDay = calendar.date(byAdding: DateComponents(day: 7), to: i.date)!
        return WeekIndex(nextDay)
    }
    
    public func index(before i: WeekIndex) -> WeekIndex {
        let previousDay = calendar.date(byAdding: DateComponents(day: -7), to: i.date)!
        return WeekIndex(previousDay)
    }
    
    public func distance(from start: WeekIndex, to end: WeekIndex) -> Int {
        return calendar.dateComponents([.day], from: start.date, to: end.date).day! / 7
    }
    
    public func index(_ i: WeekIndex, offsetBy n: Int) -> WeekIndex {
        let offsetDate = calendar.date(byAdding: DateComponents(day: 7 * n), to: i.date)!
        return WeekIndex(offsetDate)
    }
}
