//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

let detailsTransitionDuration = TimeInterval(0.5)

final class DayDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        detailsTransitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
}
