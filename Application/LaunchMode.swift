//
//  LaunchMode.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

enum LaunchMode: String {
    case appPreview02_addingEvents,
         appPreview02_swipingEvents,
         appPreview02_viewDetailsAndExport,
         appPreview02_addWeeklyGoal,
         appPreview03_widget,
         appPreview03_darkMode,
         eventsListInteractions,
         unitTest,
         uikit,
         injectedCurrentMoment

    var uiTestingDisabled: Bool { return
        self != .appPreview02_addingEvents &&
        self != .appPreview02_swipingEvents &&
        self != .appPreview02_viewDetailsAndExport &&
        self != .appPreview02_addWeeklyGoal &&
        self != .appPreview03_widget &&
        self != .appPreview03_darkMode
    }

    var currentMoment: Date {
        switch self {
        case .appPreview02_viewDetailsAndExport,
             .appPreview02_addWeeklyGoal,
             .appPreview03_widget,
             .appPreview03_darkMode:
            return UITestRepositoryConfigurator.viewAndExportToday.date
        case .unitTest:
            return DayIndex.referenceValue.date
        default:
            return .now
        }
    }
}
