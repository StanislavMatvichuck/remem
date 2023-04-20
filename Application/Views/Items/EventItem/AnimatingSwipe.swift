//
//  SwipeAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2023.
//

import UIKit

protocol AnimatingSwipe {
    func start(animated: UIView, forXDistance: CGFloat, andScaleFactor: CGFloat)
    func set(progress: CGFloat)
    func returnToStart(from: CGFloat, completion: @escaping () -> Void)
    func animateSuccess(completion: @escaping () -> Void)
    func prepareForReuse()
}

final class DefaultSwipeAnimator: AnimatingSwipe {
    let animator = UIViewPropertyAnimator(duration: 0.25, curve: .linear)
    var animated: UIView?
    var scaleFactor: CGFloat?

    func start(animated view: UIView, forXDistance: CGFloat, andScaleFactor: CGFloat) {
        animated = view
        scaleFactor = andScaleFactor
        animator.addAnimations {
            var newTransform = CGAffineTransform.identity

            newTransform = newTransform.concatenating(CGAffineTransform(
                scaleX: andScaleFactor,
                y: andScaleFactor
            ))

            newTransform = newTransform.concatenating(CGAffineTransform(
                translationX: forXDistance,
                y: 0
            ))

            view.transform = newTransform
        }
    }

    func set(progress: CGFloat) {
        animator.fractionComplete = progress
    }

    func returnToStart(from progress: CGFloat, completion: @escaping () -> Void) {
        animator.isReversed = true
        animator.continueAnimation(
            withTimingParameters: nil,
            durationFactor: progress
        )
        animator.addCompletion { _ in completion() }
    }

    func prepareForReuse() {
        animator.stopAnimation(true)
        animator.finishAnimation(at: .start)
        animated?.transform = .identity
        animated = nil
        scaleFactor = nil
    }

    func animateSuccess(completion: @escaping () -> Void) {
        guard let animated, let scaleFactor else { return }
        let scale = 1 / scaleFactor

        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.dropDuration,
            curve: .easeIn,
            animations: {
                animated.transform = animated.transform.scaledBy(
                    x: scale,
                    y: scale
                )
            }
        )

        animator.addCompletion { _ in completion() }
        animator.startAnimation()
    }
}
