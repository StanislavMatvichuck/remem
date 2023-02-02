//
//  WeekTimeline.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

import Foundation

/// where to use use it? viewModel or domain? or both?
struct WeekTimeline<Element>: RandomAccessCollection {
    var storage: [Date: Element] = [:]
    
    var startIndex = WeekIndex(Date.distantPast)
    var endIndex = WeekIndex(Date.distantPast)
    
    subscript(i: WeekIndex) -> Element? {
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
            return self[WeekIndex(date)]
        }
        set {
            self[WeekIndex(date)] = newValue
        }
    }
    
    subscript(i: Int) -> Element? { self[WeekIndex(calendar.date(byAdding: DateComponents(day: i * 7), to: startIndex.date)!)] }
    
    func index(after i: WeekIndex) -> WeekIndex {
        let nextDay = calendar.date(byAdding: DateComponents(day: 7), to: i.date)!
        return WeekIndex(nextDay)
    }
    
    func index(before i: WeekIndex) -> WeekIndex {
        let previousDay = calendar.date(byAdding: DateComponents(day: -7), to: i.date)!
        return WeekIndex(previousDay)
    }
    
    func distance(from start: WeekIndex, to end: WeekIndex) -> Int {
        return calendar.dateComponents([.day], from: start.date, to: end.date).day! / 7
    }
    
    func index(_ i: WeekIndex, offsetBy n: Int) -> WeekIndex {
        let offsetDate = calendar.date(byAdding: DateComponents(day: 7 * n), to: i.date)!
        return WeekIndex(offsetDate)
    }
}
