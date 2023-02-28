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
    private let itemFactory: ClockItemViewModelFactoring

    let items: [ClockItemViewModel]

    init(event: Event, size: Int, itemFactory: ClockItemViewModelFactoring) {
        self.size = size
        self.secondsInDay = 60 * 60 * 24
        self.secondsInSection = secondsInDay / size
        self.itemFactory = itemFactory
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
            itemFactory.make(
                index: index,
                length: max == 0 ? 0.0 : CGFloat(happeningsAmount) / max,
                size: size
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
