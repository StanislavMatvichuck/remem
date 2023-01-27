//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    private let event: Event

    let items: [ClockItemViewModel]

    init(event: Event, sorter: ClockStrategy) {
        self.items = sorter.sort(orderedByDateHappenings: event.happenings)
        self.event = event
    }
}

protocol ClockStrategy {
    func sort(orderedByDateHappenings: [Happening]) -> [ClockItemViewModel]
}

struct DefaultClockSorter: ClockStrategy {
    let size: Int
    let secondsInDay: Int
    var secondsInSection: Int { secondsInDay / size }

    init(size: Int) {
        self.size = size
        self.secondsInDay = 60 * 60 * 24
    }

    func sort(orderedByDateHappenings: [Happening]) -> [ClockItemViewModel] {
        /// happenings size is bigger than clock size
        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        for happening in orderedByDateHappenings {
            var happeningSeconds = seconds(for: happening)
            var i = 0

            while happeningSeconds >= 0 {
                happeningSeconds -= secondsInSection
                i += 1
            }

            happeningsPerSection[i - 1] += 1
        }

        let max = CGFloat(happeningsPerSection.max() ?? 0)

        return happeningsPerSection.enumerated().map { index, happeningsAmount in
            ClockItemViewModel(
                index: index,
                length: max == 0 ? 0.0 : CGFloat(happeningsAmount) / max,
                clockSize: size
            )
        }
    }

    func seconds(forSection: Int) -> Int {
        return secondsInSection * (forSection + 1)
    }

    func seconds(for happening: Happening) -> Int {
        Calendar.current.dateComponents(
            [.second],
            from: Calendar.current.startOfDay(for: happening.dateCreated),
            to: happening.dateCreated
        ).second ?? 0
    }
}
