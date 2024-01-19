//
//  EventsSortingDismissAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import UIKit

final class EventsSortingDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { EventsSortingAnimationsHelper.duration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedView = transitionContext.view(forKey: .from) else { fatalError() }

        let animator = EventsSortingAnimationsHelper.propertyAnimator(presentedView: presentedView, newOriginX: transitionContext.containerView.frame.width)

        animator.addCompletion { _ in
            let isComplete = !transitionContext.transitionWasCancelled
            if isComplete { presentedView.removeFromSuperview() }
            transitionContext.completeTransition(isComplete)
        }

        animator.startAnimation()
    }
}
