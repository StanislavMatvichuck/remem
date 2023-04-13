//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.04.2023.
//

import UIKit

class DayDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { DayDetailsAnimationsHelper.totalDuration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        makeAnimator(using: transitionContext).startAnimation()
    }

    func makeAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        fatalError("subclass must implement this")
    }

    var additionalAnimations: [() -> Void] = []

    func add(_ animation: @escaping () -> Void) {
        additionalAnimations.append(animation)
    }

    func clearAdditionalAnimations() {
        additionalAnimations = []
    }
}
