//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Domain
import Foundation

struct EventViewModel {
    let event: Event

    // MARK: - Init
    init(event: Event) {
        self.event = event
    }

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
        return event.isGoalReached(at: todayDate)
    }
}
