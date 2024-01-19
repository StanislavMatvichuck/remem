//
//  EventsSortingPresentationAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import UIKit

final class EventsSortingPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { EventsSortingAnimationsHelper.duration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentedView = transitionContext.view(forKey: .to),
            let presentedController = transitionContext.viewController(forKey: .to)
        else { fatalError("error getting necessary views for animation") }

        let finalFrame = transitionContext.finalFrame(for: presentedController)

        let startingFrame = CGRect(
            x: finalFrame.maxX,
            y: finalFrame.minY,
            width: finalFrame.width,
            height: finalFrame.height
        )

        presentedView.frame = startingFrame

        let presentingView = transitionContext.containerView
        presentingView.addSubview(presentedView)
        presentingView.bringSubviewToFront(presentedView)

        let animator = EventsSortingAnimationsHelper.propertyAnimator(
            presentedView: presentedView,
            newOriginX: finalFrame.minX
        )

        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        animator.startAnimation()
    }
}
