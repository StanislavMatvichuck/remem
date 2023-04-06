//
//  DayDetailsDismissAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import UIKit

final class DayDetailsDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { AnimationsHelper.totalDuration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let detailsView = transitionContext.view(forKey: .from),
            let backgroundView = transitionContext.containerView.subviews.first(where: { $0.backgroundColor == .secondary })
        else { fatalError("error getting necessary views for animation") }

        UIView.animate(
            withDuration: AnimationsHelper.scaleXDuration,
            animations: {
                detailsView.transform = .init(scaleX: 0.9, y: 1)
            })

        UIView.animate(
            withDuration: AnimationsHelper.positionYDuration,
            animations: {
                detailsView.frame.origin.y = transitionContext.containerView.frame.maxY
                backgroundView.alpha = 0
            },
            completion: { _ in
                detailsView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
    }
}
