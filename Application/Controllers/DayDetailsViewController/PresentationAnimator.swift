//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

final class PresentationAnimator: DayDetailsAnimator {
    var originHeight: CGFloat = 0.0

    override func makeAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard
            let detailsView = transitionContext.view(forKey: .to),
            let detailsVc = transitionContext.viewController(forKey: .to)
        else { fatalError("error getting necessary views for animation") }

        detailsView.frame = transitionContext.finalFrame(for: detailsVc)
        detailsView.layoutIfNeeded()
        detailsView.transform = CGAffineTransform(scaleX: 0.9, y: 1)

        let containerView = transitionContext.containerView
        containerView.addSubview(detailsView)
        containerView.bringSubviewToFront(detailsView)

        let duration = transitionDuration(using: transitionContext)
        let height = originHeight

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut
        )

        animator.addAnimations(DayDetailsAnimationsHelper.makePresentationSliding(
            duration: duration,
            animatedView: detailsView,
            targetHeight: height
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
