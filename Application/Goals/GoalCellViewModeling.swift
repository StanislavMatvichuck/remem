//
//  GoalCellViewModeling.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import Foundation

protocol GoalCellViewModeling: Identifiable, Equatable {
    var id: String { get }
}

extension GoalViewModel: GoalCellViewModeling {
    static func == (lhs: GoalViewModel, rhs: GoalViewModel) -> Bool {
        lhs.id == rhs.id &&
            lhs.readableDateCreated == rhs.readableDateCreated &&
            lhs.readableLeftToAchieve == rhs.readableLeftToAchieve &&
            lhs.progress == rhs.progress
    }
}
