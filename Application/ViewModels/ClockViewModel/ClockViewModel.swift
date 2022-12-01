//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    var size: Int { sections.count }
    let sections: [ClockSectionViewModel]

    init(happenings: [Happening], sorter: ClockStrategy) {
        self.sections = sorter.sort(orderedByDateHappenings: happenings)
    }
}

protocol ClockStrategy {
    func sort(orderedByDateHappenings: [Happening]) -> [ClockSectionViewModel]
}

struct DefaultClockSorter: ClockStrategy {
    let size: Int
    let secondsInDay = 60 * 60 * 24
    var secondsInSection: Int { secondsInDay / size }

    func sort(orderedByDateHappenings: [Happening]) -> [ClockSectionViewModel] {
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
            ClockSectionViewModel(
                index: index,
                length: max == 0 ? 0.0 : CGFloat(happeningsAmount) / max
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
