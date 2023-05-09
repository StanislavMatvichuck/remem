//
//  ExtensionEventWeeklyGoalViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

extension EventWeeklyGoalViewModel.State {
    var color: UIColor {
        switch self {
        case .achieved: return UIColor.goal_achieved
        case .notAchieved: return UIColor.secondary_dimmed
        }
    }
}
