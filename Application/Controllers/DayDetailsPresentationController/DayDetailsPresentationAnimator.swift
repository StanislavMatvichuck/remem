//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

final class DayDetailsPresentationAnimator: DayDetailsAnimator {
    static let originHeight: CGFloat = {
        let screenHeightLeftover: CGFloat = .screenH - .screenW * 0.66666 * 1.6
        let originHeight: CGFloat = screenHeightLeftover / 2
        return originHeight
    }()

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

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeInOut
        )

        animator.addAnimations(DayDetailsAnimationsHelper.makePresentationSliding(
            animatedView: detailsView,
            targetHeight: Self.originHeight
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
