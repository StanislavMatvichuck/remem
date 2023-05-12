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
        case .achieved: return UIColor.bg_goal_achieved
        case .notAchieved: return UIColor.bg_goal
        }
    }
}
