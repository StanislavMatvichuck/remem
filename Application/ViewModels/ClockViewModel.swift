//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    let cells: [ClockCellViewModel]

    init(event: Event, size: Int) {
        let secondsInDay = 60 * 60 * 24
        let secondsInSection = secondsInDay / size

        var happeningsPerSection: [Int] = Array(repeating: 0, count: size)

        for happening in event.happenings {
            var happeningSeconds = Self.seconds(for: happening)
            var i = 0

            while happeningSeconds >= 0 {
                happeningSeconds -= secondsInSection
                i += 1
            }

            happeningsPerSection[i - 1] += 1
        }

        let max = CGFloat(happeningsPerSection.max() ?? 0)

        self.cells = happeningsPerSection.enumerated().map { index, happeningsAmount in
            ClockCellViewModel(
                index: index,
                length: max == 0 ? 0.0 : CGFloat(happeningsAmount) / max,
                clockSize: size
            )
        }
    }

    private static func seconds(for happening: Happening) -> Int {
        Calendar.current.dateComponents(
            [.second],
            from: Calendar.current.startOfDay(for: happening.dateCreated),
            to: happening.dateCreated
        ).second ?? 0
    }
}
