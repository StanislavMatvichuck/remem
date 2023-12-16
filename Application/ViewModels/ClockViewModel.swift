//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    private static let secondsInDay = 60 * 60 * 24
    private static let secondsInHalfOfDay = secondsInDay / 2

    let cells: [ClockCellViewModel]

    init(withDayHappeningsOf event: Event, andSize size: Int) {
        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        event.happenings.forEach {
            guard $0.secondsFromStartOfTheDay < Self.secondsInHalfOfDay else { return }
            happeningsPerSection = Self.add(happening: $0, to: happeningsPerSection, withLowerBound: 0)
        }

        self.cells = Self.make(happeningsPerSection: happeningsPerSection)
    }

    init(withNightHappeningsOf event: Event, andSize size: Int) {
        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        event.happenings.forEach {
            happeningsPerSection = Self.add(happening: $0, to: happeningsPerSection, withLowerBound: Self.secondsInHalfOfDay)
        }

        self.cells = Self.make(happeningsPerSection: happeningsPerSection)
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
