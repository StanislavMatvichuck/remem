//
//  DayChangeWatcher.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.02.2023.
//

import UIKit

protocol DayChangeWatcherDelegate: AnyObject {
    func handleDayChange()
}

final class DayChangeWatcher {
    weak var delegate: DayChangeWatcherDelegate?

    private var lastWatchDay: DayIndex?

    func watch(_ date: Date = .now) {
        let newDay = DayIndex(date)

        if let lastWatchDay, lastWatchDay != newDay {
            delegate?.handleDayChange()
        }

        lastWatchDay = newDay
    }
}
