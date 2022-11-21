//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import Domain
import Foundation
import IosUseCases

struct WeekCellViewModel {
    let date: Date
    let event: Event
    /// Used by GoalEditUseCase
    private var overriddenGoalsAmount: Int?
    // MARK: - Init
    init(date: Date, event: Event) {
        self.date = date
        self.event = event
    }

    var dayNumber: String { String(Calendar.current.dateComponents([.day], from: date).day ?? 0) }
    var isAchieved: Bool {
        if let overriddenGoalsAmount = overriddenGoalsAmount {
            if overriddenGoalsAmount == 0 { return false }
            return happeningsTimings.count >= overriddenGoalsAmount
        } else {
            return event.isGoalReached(at: date)
        }
    }

    var amount: String { String(event.happenings(forDay: date).count) }
    var goalsAmount: Int { overriddenGoalsAmount ?? event.goal(at: date)?.amount ?? 0 }

    var isToday: Bool { Calendar.current.isDateInToday(date) }
    var happeningsTimings: [String] {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        return event.happenings(forDay: date).map { happening in
            formatter.string(from: happening.dateCreated)
        }
    }
}
