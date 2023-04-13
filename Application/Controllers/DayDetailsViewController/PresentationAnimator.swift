//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

final class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originHeight: CGFloat = 0.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { AnimationsHelper.totalDuration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
        let yPositionDelay = AnimationsHelper.positionYDelay / AnimationsHelper.totalDuration
        let xScaleDelay = AnimationsHelper.scaleXDelay / AnimationsHelper.totalDuration

        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .linear
        )

        animator.addAnimations({
            detailsView.frame.origin.y = self.originHeight
        }, delayFactor: yPositionDelay)

        animator.addAnimations({
            detailsView.transform = .identity
        }, delayFactor: xScaleDelay)

        for animation in additionalAnimations {
            animator.addAnimations(animation)
        }

        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        animator.startAnimation()
    }

    private var additionalAnimations: [() -> Void] = []

    func add(animation: @escaping () -> Void) {
        additionalAnimations.append(animation)
    }

    func clearAdditionalAnimations() {
        additionalAnimations = []
    }
}
