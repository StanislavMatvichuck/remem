//
//  LaunchMode.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.06.2023.
//

import Domain
import Foundation

/// This type is duplicated at `ApplicationUITests` target
enum LaunchMode: String {
    case appPreview,
         unitTest,
         uikit,
         injectedCurrentMoment,
         functionalTest,
         performanceTest,
         performanceTestWritesData

    var uiTestingDisabled: Bool { return self != .appPreview }

    var currentMoment: Date { switch self {
    case .unitTest: return DayIndex.referenceValue.date
    default: return .now
    } }
}
