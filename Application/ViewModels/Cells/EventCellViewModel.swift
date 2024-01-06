//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventCellViewModel: EventsListItemViewModeling {
    enum Animations { case swipe, aboveSwipe, belowSwipe, none }

    typealias TapHandler = () -> Void
    typealias SwipeHandler = () -> Void
    typealias RenameActionHandler = (EventCellViewModel) -> Void
    typealias DeleteActionHandler = () -> Void
    typealias RenameHandler = (String, Event) -> Void

    var identifier: String { event.id }

    private let event: Event
    private let valueAmount: Int

    static let rename = String(localizationId: "button.rename")
    static let delete = String(localizationId: "button.delete")

    let title: String
    let value: String
    let timeSince: String
    let hintEnabled: Bool
    let progress: CGFloat
    let progressState: EventWeeklyGoalViewModel.State
    let goalAmount: String?

    let tapHandler: TapHandler
    let swipeHandler: SwipeHandler
    let renameActionHandler: RenameActionHandler
    let deleteActionHandler: DeleteActionHandler
    let renameHandler: RenameHandler
    let currentMoment: Date
    var animation: Animations

    init(
        event: Event,
        hintEnabled: Bool,
        currentMoment: Date,
        tapHandler: @escaping TapHandler,
        swipeHandler: @escaping SwipeHandler,
        renameActionHandler: @escaping RenameActionHandler,
        deleteActionHandler: @escaping DeleteActionHandler,
        renameHandler: @escaping RenameHandler,
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
        self.renameActionHandler = renameActionHandler
        self.deleteActionHandler = deleteActionHandler
        self.renameHandler = renameHandler
    }

    func isValueIncreased(_ oldValue: EventCellViewModel) -> Bool {
        valueAmount > oldValue.valueAmount
    }

    func isProgressIncreased(_ oldValue: EventCellViewModel) -> Bool {
        progress > oldValue.progress && progress <= 1
    }

    func rename(to: String) { renameHandler(to, event) }

    func clone(withAnimation: Animations) -> EventCellViewModel {
        EventCellViewModel(
            event: event,
            hintEnabled: hintEnabled,
            currentMoment: currentMoment,
            tapHandler: tapHandler,
            swipeHandler: swipeHandler,
            renameActionHandler: renameActionHandler,
            deleteActionHandler: deleteActionHandler,
            renameHandler: renameHandler,
            animation: withAnimation
        )
    }

    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        lhs.title == rhs.title &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.value == rhs.value &&
            lhs.timeSince == rhs.timeSince &&
            lhs.progress == rhs.progress &&
            lhs.goalAmount == rhs.goalAmount &&
            lhs.animation == rhs.animation
    }

    static func timeSinceDate(date: Date, now: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        return formatter.string(from: date, to: now) ?? ""
    }
}
