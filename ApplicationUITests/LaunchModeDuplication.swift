//
//  LaunchModeDuplication.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 11.03.2024.
//

import Foundation

/// Duplication from `Application` target
enum LaunchMode: String {
    case appPreview,
         unitTest,
         uikit,
         injectedCurrentMoment,
         functionalTest,
         performanceTest,
         performanceTestWritesData
}
