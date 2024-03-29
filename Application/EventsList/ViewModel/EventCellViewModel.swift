//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventCellViewModel {
    var id: String { event.id } /// used by `EventsListCellViewModel`

    enum Animations { case swipe, aboveSwipe, belowSwipe, none }

    static let rename = String(localizationId: "button.rename")
    static let delete = String(localizationId: "button.delete")

    private let event: Event
    private let valueAmount: Int

    let title: String
    let value: String
    let timeSince: String
    let hintEnabled: Bool
    let progress: CGFloat
    let progressState: EventWeeklyGoalViewModel.State
    let goalAmount: String?
    var animation: Animations

    private let currentMoment: Date

    init(
        event: Event,
        hintEnabled: Bool,
        currentMoment: Date,
        animation: Animations
    ) {
        self.animation = animation
        self.currentMoment = currentMoment
        self.valueAmount = event.happeningsAmount(forWeekAt: currentMoment)
        self.event = event
        let weeklyGoalDescription = EventWeeklyGoalViewModel(weekDate: currentMoment, event: event, goalEditable: false)

        self.title = event.name
        self.hintEnabled = hintEnabled
        self.timeSince = {
            if let happening = event.happenings.last {
                return Self.timeSinceDate(date: happening.dateCreated, now: currentMoment)
            } else {
                return String(localizationId: "eventsList.timeSince")
            }
        }()

        self.goalAmount = weeklyGoalDescription.goal
        self.progress = weeklyGoalDescription.progress
        self.progressState = weeklyGoalDescription.state

        if let goal = goalAmount {
            self.value = "\(valueAmount)/\(goal)"
        } else {
            self.value = "\(valueAmount)"
        }
    }

    func isValueIncreased(_ oldValue: EventCellViewModel) -> Bool {
        valueAmount > oldValue.valueAmount
    }

    func isProgressIncreased(_ oldValue: EventCellViewModel) -> Bool {
        progress > oldValue.progress && progress <= 1
    }

    func clone(withAnimation: Animations) -> EventCellViewModel {
        EventCellViewModel(
            event: event,
            hintEnabled: hintEnabled,
            currentMoment: currentMoment,
            animation: withAnimation
        )
    }

    static func timeSinceDate(date: Date, now: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        return formatter.string(from: date, to: now) ?? ""
    }
}
