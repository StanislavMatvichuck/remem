//
//  DayChangeWatcher.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

import UIKit

final class DayChangeWatcher {
    var delegate: Updating?

    private var lastWatchDay: DayIndex?

    func watch(_ date: Date = .now) {
        let newDay = DayIndex(date)

        if let lastWatchDay, lastWatchDay != newDay {
            delegate?.update()
        }

        lastWatchDay = newDay
    }
}
