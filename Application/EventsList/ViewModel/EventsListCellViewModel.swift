//
//  EventsListCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.02.2024.
//

import Foundation

protocol EventsListCellViewModel: Identifiable, Equatable {
    var id: String { get }
    func requiresUpdate(oldValue: any EventsListCellViewModel) -> Bool
}

extension HintCellViewModel: EventsListCellViewModel {
    var id: String { "HintCellViewModel" }

    static func == (lhs: HintCellViewModel, rhs: HintCellViewModel) -> Bool {
        lhs.title == rhs.title &&
            lhs.highlighted == rhs.highlighted
    }

    func requiresUpdate(oldValue: any EventsListCellViewModel) -> Bool {
        id == oldValue.id && self != oldValue as? HintCellViewModel
    }
}

extension EventCellViewModel: EventsListCellViewModel {
    /// id: String uses internal property

    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        lhs.title == rhs.title &&
            lhs.value == rhs.value &&
            lhs.timeSince == rhs.timeSince &&
            lhs.hintEnabled == rhs.hintEnabled &&
            lhs.progress == rhs.progress &&
            lhs.progressState == rhs.progressState &&
            lhs.goalAmount == rhs.goalAmount &&
            lhs.animation == rhs.animation
    }

    func requiresUpdate(oldValue: any EventsListCellViewModel) -> Bool {
        let identifiersCondition = id == oldValue.id
        let equalityCondition = self != oldValue as? EventCellViewModel
        let animationCondition = animation != .none
        return identifiersCondition && (equalityCondition || animationCondition)
    }
}

extension CreateEventCellViewModel: EventsListCellViewModel, Equatable {
    var id: String { "CreateEventCellViewModel" }

    static func == (lhs: CreateEventCellViewModel, rhs: CreateEventCellViewModel) -> Bool {
        lhs.isHighlighted == rhs.isHighlighted
    }

    func requiresUpdate(oldValue: any EventsListCellViewModel) -> Bool {
        id == oldValue.id && self != oldValue as? CreateEventCellViewModel
    }
}
