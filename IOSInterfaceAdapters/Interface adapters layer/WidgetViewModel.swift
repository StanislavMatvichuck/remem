//
//  WidgetViewModel.swift
//  IOSInterfaceAdapters
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Foundation
import RememDomain
import WidgetKit

public struct WidgetViewModel: TimelineEntry {
    public let date: Date
    public let listViewModel: EventsListViewModelState

    public init(date: Date = Date(), listViewModel: EventsListViewModelState) {
        self.listViewModel = listViewModel
        self.date = date
    }

    public func eventViewModel(atIndex: Int) -> EventCellViewModelingState? {
        guard let event = listViewModel.event(at: atIndex) else { return nil }

        let viewModel = WidgetEventViewModel(event: event)

        return viewModel
    }
}

public struct WidgetEventsListViewModel: EventsListViewModelState {
    public var eventsAmount: Int { events.count }
    public var isAddButtonHighlighted: Bool { events.count == 0 }
    public var hint: HintState {
        if events.count == 0 { return .empty }
        if events.filter({ $0.happenings.count > 0 }).count == 0 { return .placeFirstMark }
        if events.filter({ $0.dateVisited != nil }).count == 0 { return .pressMe }
        return .swipeLeft
    }

    public func event(at index: Int) -> Event? {
        guard index < events.count, index >= 0 else { return nil }
        return events[index]
    }

    private let events: [Event]

    public init(events: [Event]) {
        self.events = events
    }
}

public struct WidgetEventViewModel: EventCellViewModelingState, Codable {
    public var name: String
    public var amount: String
    public var hasGoal: Bool
    public var goalReached: Bool

    public init(name: String, amount: String, hasGoal: Bool, goalReached: Bool) {
        self.name = name
        self.amount = amount
        self.hasGoal = hasGoal
        self.goalReached = goalReached
    }

    public init(event: Event) {
        var name: String { event.name }
        var amount: String {
            let todayDate = Date.now
            let todayHappeningsCount = event.happenings(forDay: todayDate).count
            if let todayGoal = event.goal(at: todayDate), todayGoal.amount > 0 {
                return "\(todayHappeningsCount)/\(todayGoal.amount)"
            } else {
                return "\(todayHappeningsCount)"
            }
        }

        var hasGoal: Bool {
            let todayDate = Date.now
            if let goal = event.goal(at: todayDate) {
                return goal.amount > 0
            }
            return false
        }

        var goalReached: Bool {
            let todayDate = Date.now
            return event.goal(at: todayDate)?.isReached(at: todayDate) ?? false
        }

        self.init(name: name, amount: amount, hasGoal: hasGoal, goalReached: goalReached)
    }
}
