//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

final class DayDetailsPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originHeight: CGFloat = 0.0

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { AnimationsHelper.totalDuration }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard
            let detailsView = transitionContext.view(forKey: .to)
        else { fatalError("error getting necessary views for animation") }

        let backgroundView: UIView = {
            let backgroundView = UIView(frame: containerView.frame)
            backgroundView.backgroundColor = .secondary
            backgroundView.alpha = 0
            return backgroundView
        }()

        let detailsFrame = CGRect(
            x: .layoutSquare / 2,
            y: containerView.frame.maxY,
            width: .layoutSquare * 6,
            height: .layoutSquare * 9
        )

        detailsView.frame = detailsFrame
        detailsView.transform = CGAffineTransform(scaleX: 0.9, y: 1)

        containerView.addSubview(detailsView)
        containerView.addSubview(backgroundView)
        containerView.bringSubviewToFront(detailsView)

        UIView.animate(
            withDuration: AnimationsHelper.scaleXDuration,
            delay: AnimationsHelper.scaleXDelay,
            animations: {
                detailsView.transform = .init(scaleX: 1, y: 1)
            }
        )

        UIView.animate(
            withDuration: AnimationsHelper.positionYDuration,
            delay: AnimationsHelper.positionYDelay,
            animations: {
                detailsView.frame.origin.y = self.originHeight
                backgroundView.alpha = 0.33
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
