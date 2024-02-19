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

    typealias TapHandler = () -> Void
    typealias SwipeHandler = () -> Void
    typealias RemoveHandler = () -> Void

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

    let tapHandler: TapHandler
    let swipeHandler: SwipeHandler
    let removeHandler: RemoveHandler
    private let currentMoment: Date

    init(
        event: Event,
        hintEnabled: Bool,
        currentMoment: Date,
        tapHandler: @escaping TapHandler,
        swipeHandler: @escaping SwipeHandler,
        removeHandler: @escaping RemoveHandler,
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

        self.tapHandler = tapHandler
        self.swipeHandler = swipeHandler
        self.removeHandler = removeHandler
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
            tapHandler: tapHandler,
            swipeHandler: swipeHandler,
            removeHandler: removeHandler,
            animation: withAnimation
        )
    }

    func remove() { removeHandler() }

    static func timeSinceDate(date: Date, now: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        return formatter.string(from: date, to: now) ?? ""
    }
}
