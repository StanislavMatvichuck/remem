//
//  AnimationsHelper.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import Foundation

struct AnimationsHelper {
    static let frameDuration = TimeInterval(1.0 / 60.0)

    /// DayDetails
    static let scaleXDuration = frameDuration * 5
    static let scaleXDelay = totalDuration - scaleXDuration
    static let positionYDuration = frameDuration * 25
    static let positionYDelay = frameDuration * 5
    static let fadeDuration = positionYDuration
    static let weekItemPositionYDuration = frameDuration * 15
    static let weekItemPositionYDelay = frameDuration * 15
    static let weekItemScaleXDelay = frameDuration * 25
    static let totalDuration = AnimationsHelper.frameDuration * 30
}
