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
    static let forwardDuration = Self.frameDuration * 16
    static let progressMovementDuration = dropDuration + forwardDuration

    static func animateHappening(_ view: EventCellView) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Self.forwardDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                view.transform = CGAffineTransform(
                    translationX: .buttonHeight,
                    y: 0
                )
            },
            completion: { _ in Self.animateBack(view) }
        )
    }

    static func animate(neighbour: EventCellView, isAbove: Bool) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Self.forwardDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                let verticalOffset = (2 * CGFloat.layoutSquare - .buttonHeight) / 2
                neighbour.transform = CGAffineTransform(
                    translationX: 0, y: isAbove ? -verticalOffset : verticalOffset
                )
            },
            completion: { _ in Self.animateBack(neighbour) }
        )
    }

    static func animateBack(_ view: UIView) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Self.forwardDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { view.transform = .identity }
        )
    }
}
