//
//  DayChangeWatcher.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

import Foundation

protocol Watching { func watch(_ date: Date) }

final class DayWatcher: Watching {
    var delegate: Updating?

    private var lastWatchDay: DayIndex?

    func watch(_ date: Date) {
        let newDay = DayIndex(date)

        if let lastWatchDay, lastWatchDay != newDay {
            delegate?.update()
        }

        lastWatchDay = newDay
    }
}

final class MinuteWatcher: Watching {
    var delegate: Updating?

    private var lastWatchMinute: MinuteIndex?

    func watch(_ date: Date) {
        let newMinute = MinuteIndex(date)

        if let lastWatchMinute, lastWatchMinute != newMinute {
            delegate?.update()
        }

        lastWatchMinute = newMinute
    }
}
