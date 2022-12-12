//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventItemViewModel {
    typealias onSelect = (_: Event) -> Void
    typealias onSwipe = (_: Event) -> Void
    typealias onRemove = (_: Event) -> Void
    typealias onRename = (_: Event, _: String) -> Void

    let event: Event
    let today: DayComponents
    let onSelect: onSelect
    let onSwipe: onSwipe
    let onRemove: onRemove
    let onRename: onRename

    init(
        event: Event,
        today: DayComponents,
        onSelect: @escaping onSelect,
        onSwipe: @escaping onSwipe,
        onRemove: @escaping onRemove,
        onRename: @escaping onRename
    ) {
        self.event = event
        self.today = today
        self.onSelect = onSelect
        self.onSwipe = onSwipe
        self.onRename = onRename
        self.onRemove = onRemove
    }

    var name: String { event.name }

    var amount: String {
        let todayHappeningsCount = event.happenings(forDayComponents: today).count
        return String(todayHappeningsCount)
    }
}
