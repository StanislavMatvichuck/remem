//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

protocol ClockViewModelFactoring {
    func makeClockViewModel(event: Event) -> ClockViewModel
}

struct ClockViewModel: EventDependantViewModel {
    private let event: Event
    private let selfFactory: ClockViewModelFactoring
    let eventId: String
    let items: [ClockItemViewModel]

    init(
        event: Event,
        sorter: ClockStrategy,
        selfFactory: ClockViewModelFactoring
    ) {
        self.items = sorter.sort(orderedByDateHappenings: event.happenings)
        self.event = event
        self.eventId = event.id
        self.selfFactory = selfFactory
    }

    func copy(newEvent: Event) -> ClockViewModel {
        selfFactory.makeClockViewModel(event: newEvent)
    }
}

protocol ClockStrategy {
    func sort(orderedByDateHappenings: [Happening]) -> [ClockItemViewModel]
}

struct DefaultClockSorter: ClockStrategy {
    let size: Int
    let secondsInDay = 60 * 60 * 24
    var secondsInSection: Int { secondsInDay / size }

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
