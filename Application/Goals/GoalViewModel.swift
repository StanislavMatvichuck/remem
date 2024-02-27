//
//  GoalViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Domain
import Foundation

struct GoalViewModel {
    private let goal: Goal
    private static let textCreatedAt = String(localizationId: "goal.createdAt")
    private static let textLeftToAchieve = String(localizationId: "goal.leftToAchieve")
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    let readableDateCreated: String
    let readableLeftToAchieve: String
    let progress: CGFloat
    let isAchieved: Bool

    init(goal: Goal) {
        self.goal = goal
        readableDateCreated =
            Self.textCreatedAt + " " +
            Self.dateFormatter.string(from: goal.dateCreated)
        readableLeftToAchieve =
            String(describing: goal.leftToAchieve) + " " +
            Self.textLeftToAchieve

        progress = 0
        isAchieved = false
    }
}
