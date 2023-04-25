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
    private let size: Int
    private let secondsInDay: Int
    private let secondsInSection: Int

    let items: [ClockCellViewModel]

    init(event: Event, size: Int) {
        self.size = size
        self.secondsInDay = 60 * 60 * 24
        self.secondsInSection = secondsInDay / size
        self.event = event

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

        self.items = happeningsPerSection.enumerated().map { index, happeningsAmount in
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
