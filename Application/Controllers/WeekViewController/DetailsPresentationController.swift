//
//  DetailsPresentationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2023.
//

import UIKit

final class DetailsPresentationController: UIPresentationController {
    let weekViewController: WeekViewController
    let dayDetailsViewController: DayDetailsViewController
    var presentedDayIndex: IndexPath?
    var transition: UIPercentDrivenInteractiveTransition { weekViewController.dismissTransition }

    init(week: WeekViewController, day: DayDetailsViewController, dayIndex: IndexPath) {
        self.weekViewController = week
        self.dayDetailsViewController = day
        self.presentedDayIndex = dayIndex
        super.init(presentedViewController: day, presenting: nil)
    }

    lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: containerView!.frame)
        backgroundView.backgroundColor = .secondary
        backgroundView.alpha = 0
        backgroundView.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handle)
        ))
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        return backgroundView
    }()

    override func presentationTransitionWillBegin() {
        containerView?.addSubview(backgroundView)

        guard let index = weekViewController.animatedCellIndex,
              let animatedCell = weekViewController.viewRoot.collection.cellForItem(at: index)
        else { return }

        weekViewController.presentationAnimator.add {
            UIView.animateKeyframes(
                withDuration: AnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 1 / 3,
                        animations: {
                            animatedCell.frame.origin.y -= .layoutSquare * 4
                        }
                    )

                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 1 / 6,
                        animations: {
                            animatedCell.transform = .init(scaleX: 0.8, y: 1)
                        }
                    )
                }
            )
        }

        weekViewController.presentationAnimator.add {
            UIView.animateKeyframes(
                withDuration: AnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0.5,
                        relativeDuration: 0.5,
                        animations: {
                            self.backgroundView.alpha = 0.5
                        }
                    )
                }
            )
        }
    }

    override func presentationTransitionDidEnd(_: Bool) {
        weekViewController.presentationAnimator.clearAdditionalAnimations()
    }

    override func dismissalTransitionWillBegin() {
        guard let index = weekViewController.animatedCellIndex,
              let animatedCell = weekViewController.viewRoot.collection.cellForItem(at: index)
        else { return }

        weekViewController.dismissAnimator.add {
            UIView.animateKeyframes(
                withDuration: AnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 3 / 6,
                        relativeDuration: 1 / 2,
                        animations: {
                            animatedCell.frame.origin.y += .layoutSquare * 4
                        }
                    )

                    UIView.addKeyframe(
                        withRelativeStartTime: 5 / 6,
                        relativeDuration: 1 / 6,
                        animations: {
                            animatedCell.transform = .identity
                        }
                    )
                }
            )
        }

        weekViewController.dismissAnimator.add {
            UIView.animateKeyframes(
                withDuration: AnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 0.5,
                        animations: {
                            self.backgroundView.alpha = 0
                        }
                    )
                }
            )
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        transition.wantsInteractiveStart = false
        weekViewController.dismissAnimator.clearAdditionalAnimations()

        if completed {
            backgroundView.removeFromSuperview()
            weekViewController.animatedCellIndex = nil
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(
            x: .layoutSquare,
            y: containerView?.frame.maxY ?? 0,
            width: .layoutSquare * 5,
            height: .layoutSquare * 9
        )
    }

    @objc func handle(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view else { return }

        let verticalOffset = pan.translation(in: view).y
        let progress = max(0.0, min(1.0, verticalOffset / 300))

        if pan.state == .began {
            transition.wantsInteractiveStart = true
            presentingViewController.dismiss(animated: true)
        } else if pan.state == .changed {
            transition.update(progress)
        } else if pan.state == .ended {
            if progress >= 0.5 {
                transition.finish()
            } else {
                transition.cancel()
            }
        }
    }

    @objc func handleTap(_: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }

    private func prepareForAnimation(_ view: UIView) {
        view.frame.origin.y = .layoutSquare * -4
        view.transform = .init(scaleX: 0.8, y: 1)
    }
}
