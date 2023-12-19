//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    enum ClockType {
        case day, night

        var symbols: [String] {
            switch self {
            case .day: return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
            case .night: return ["12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
            }
        }

        var imageName: String {
            switch self {
            case .day: return "sun.max"
            case .night: return "moon.stars"
            }
        }
    }

    private static let secondsInDay = 60 * 60 * 24
    private static let secondsInHalfOfDay = secondsInDay / 2

    let type: ClockType
    let cells: [ClockCellViewModel]

    init(event: Event, size: Int, type: ClockType) {
        switch type {
        case .day: self.init(withDayHappeningsOf: event, andSize: size)
        case .night: self.init(withNightHappeningsOf: event, andSize: size)
        }
    }

    private init(withDayHappeningsOf event: Event, andSize size: Int) {
        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        event.happenings.forEach {
            guard $0.secondsFromStartOfTheDay < Self.secondsInHalfOfDay else { return }
            happeningsPerSection = Self.add(happening: $0, to: happeningsPerSection, withLowerBound: 0)
        }

        self.cells = Self.make(happeningsPerSection: happeningsPerSection)
        self.type = .day
    }

    private init(withNightHappeningsOf event: Event, andSize size: Int) {
        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        event.happenings.forEach {
            happeningsPerSection = Self.add(happening: $0, to: happeningsPerSection, withLowerBound: Self.secondsInHalfOfDay)
        }

        self.cells = Self.make(happeningsPerSection: happeningsPerSection)
        self.type = .night
    }

    private static func add(happening: Happening, to happeningsPerSection: [Int], withLowerBound: Int) -> [Int] {
        let secondsInSection = Self.secondsInHalfOfDay / happeningsPerSection.count

        var cellIndex = 0
        var happeningSeconds = happening.secondsFromStartOfTheDay
        var newHappeningsPerSection = happeningsPerSection

        while happeningSeconds >= withLowerBound {
            happeningSeconds -= secondsInSection
            cellIndex += 1
        }

        let insertionIndex = cellIndex - 1
        if insertionIndex >= 0 {
            newHappeningsPerSection[insertionIndex] += 1
        }

        return newHappeningsPerSection
    }

    private static func make(happeningsPerSection: [Int]) -> [ClockCellViewModel] {
        let max = CGFloat(happeningsPerSection.max() ?? 0)
        return happeningsPerSection.enumerated().map { index, happeningsAmount in
            ClockCellViewModel(
                index: index,
                length: max == 0 ? 0.0 : CGFloat(happeningsAmount) / max,
                clockSize: happeningsPerSection.count
            )
        }
    }
}

extension Happening {
    var secondsFromStartOfTheDay: Int {
        Calendar.current.dateComponents(
            [.second],
            from: Calendar.current.startOfDay(for: dateCreated),
            to: dateCreated
        ).second ?? 0
    }
}
