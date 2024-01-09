//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

final class DayDetailsPresentationAnimator: DayDetailsAnimator {
    override func makeAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard
            let detailsView = transitionContext.view(forKey: .to),
            let detailsVc = transitionContext.viewController(forKey: .to)
        else { fatalError("error getting necessary views for animation") }

        let finalFrame = transitionContext.finalFrame(for: detailsVc)
        let startingFrame = CGRect(
            x: finalFrame.minX,
            y: transitionContext.containerView.frame.maxY,
            width: finalFrame.width,
            height: finalFrame.height
        )
        detailsView.frame = startingFrame
        detailsView.layoutIfNeeded()
        detailsView.transform = CGAffineTransform(scaleX: 0.9, y: 1)

        let containerView = transitionContext.containerView
        containerView.addSubview(detailsView)
        containerView.bringSubviewToFront(detailsView)

        let duration = transitionDuration(using: transitionContext)

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut
        )

        animator.addAnimations(DayDetailsAnimationsHelper.makePresentationSliding(
            animatedView: detailsView,
            targetHeight: finalFrame.minY
        ))

        for animation in additionalAnimations {
            animator.addAnimations(animation)
        }

        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        return animator
    }
}
