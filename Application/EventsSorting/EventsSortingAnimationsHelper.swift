//
//  EventsSortingAnimationsHelper.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import UIKit

struct EventsSortingAnimationsHelper {
    static let duration: TimeInterval = 0.3

    static func propertyAnimator(presentedView: UIView, newOriginX: CGFloat) -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(
            duration: Self.duration,
            curve: .easeInOut
        )

        animator.addAnimations {
            UIView.animateKeyframes(
                withDuration: Self.duration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 1
                    ) {
                        presentedView.frame.origin.x = newOriginX
                    }
                }
            )
        }

        return animator
    }
}
