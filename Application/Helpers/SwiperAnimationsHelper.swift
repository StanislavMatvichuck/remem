//
//  SwiperAnimationsHelper.swift
//  Application
//
//  Created by Stanislav Matvichuck on 15.04.2023.
//

import UIKit

struct SwiperAnimationsHelper {
    typealias AnimationBlock = () -> Void
    static let frameDuration = TimeInterval(1.0 / 60.0)
    static let dropDuration = Self.frameDuration * 12
    static let forwardDuration = Self.frameDuration * 7
}
