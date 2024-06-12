//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventCellViewModel {
    enum Animations { case swipe, aboveSwipe, belowSwipe, none }

    private let event: Event
    private let valueAmount: Int

    var eventId: String { event.id }
    let title: String
    let value: String
    let timeSince: String
    let goal: GoalViewModel?
    var animation: Animations

    private let currentMoment: Date

    init(
        event: Event,
        hintEnabled: Bool,
        currentMoment: Date,
        animation: Animations,
        goal: GoalViewModel?
    ) {
        self.animation = animation
        self.currentMoment = currentMoment
        self.valueAmount = event.happeningsCount
        self.goal = goal
        self.event = event

        self.title = event.name
        self.timeSince = {
            if let happening = event.happenings.last {
                return Self.timeSinceDate(date: happening.dateCreated, now: currentMoment)
            } else {
                return String(localizationId: localizationIdEventsListEventCellTimeSince)
            }
        }()

        self.value = "\(valueAmount)"
    }

    private static func timeSinceDate(date: Date, now: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        return formatter.string(from: date, to: now) ?? ""
    }
}
