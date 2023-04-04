//
//  DayDetailsAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.03.2023.
//

import UIKit

let detailsTransitionDuration = TimeInterval(0.5)

final class DayDetailsAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var originHeight: CGFloat = 0.0
    var presenting = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        detailsTransitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        presenting ?
            animatePresentation(transitionContext) :
            animateDismissal(transitionContext)
    }

    private func animatePresentation(_ transitionContext: UIViewControllerContextTransitioning) {
        addBackgroundView(transitionContext)
        addDetailsView(transitionContext) { flag in
            transitionContext.completeTransition(flag)
        }
    }

    private func addDetailsView(
        _ transitionContext: UIViewControllerContextTransitioning,
        completion: @escaping (Bool) -> ())
    {
        let containerView = transitionContext.containerView

        guard
            let detailsView = transitionContext.view(forKey: .to)
        else { fatalError("error getting necessary views for animation") }

        let detailsFrame = CGRect(
            x: .layoutSquare / 2,
            y: containerView.frame.maxY,
            width: .layoutSquare * 6,
            height: .layoutSquare * 9)

        detailsView.frame = detailsFrame

        containerView.addSubview(detailsView)
        containerView.bringSubviewToFront(detailsView)

        UIView.animate(
            withDuration: detailsTransitionDuration,
            animations: {
                detailsView.frame.origin.y = self.originHeight
            },
            completion: completion)
    }

    private func addBackgroundView(_ transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let backgroundView = UIView(frame: containerView.frame)
        backgroundView.backgroundColor = .secondary
        backgroundView.alpha = 0.33
        containerView.addSubview(backgroundView)
    }

    private func animateDismissal(_ transitionContext: UIViewControllerContextTransitioning) {
        guard
            let detailsView = transitionContext.view(forKey: .from)
        else { fatalError("error getting necessary views for animation") }

        UIView.animate(
            withDuration: detailsTransitionDuration,
            animations: {
                detailsView.frame.origin.y = transitionContext.containerView.frame.maxY
            },
            completion: { flag in
                detailsView.removeFromSuperview()
                transitionContext.completeTransition(flag)
            })
    }
}
