//
//  LaunchMode.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Foundation

enum LaunchMode: String {
    case appPreview02_addingEvents,
         appPreview02_swipingEvents,
         appPreview02_viewDetailsAndExport,
         appPreview02_addWeeklyGoal,
         appPreview03_widget,
         appPreview03_darkMode,
         unitTest,
         uikit

    var currentMomentInjected: Bool { return
        self == .appPreview02_viewDetailsAndExport ||
        self == .appPreview02_addWeeklyGoal ||
        self == .appPreview03_widget ||
        self == .appPreview03_darkMode
    }

    var uiTestingDisabled: Bool { return
        self != .appPreview02_addingEvents &&
        self != .appPreview02_swipingEvents &&
        self != .appPreview02_viewDetailsAndExport &&
        self != .appPreview02_addWeeklyGoal &&
        self != .appPreview03_widget &&
        self != .appPreview03_darkMode
    }
}
