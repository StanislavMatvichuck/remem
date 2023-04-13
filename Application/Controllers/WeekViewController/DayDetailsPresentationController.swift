//
//  DetailsPresentationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2023.
//

import UIKit

final class DayDetailsPresentationController: UIPresentationController {
    let weekViewController: WeekViewController
    let dayDetailsViewController: DayDetailsViewController
    var transition: UIPercentDrivenInteractiveTransition { weekViewController.dismissTransition }

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

    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(
            x: .layoutSquare,
            y: containerView?.frame.maxY ?? 0,
            width: .layoutSquare * 5,
            height: .layoutSquare * 9
        )
    }

    init(week: WeekViewController, day: DayDetailsViewController) {
        self.weekViewController = week
        self.dayDetailsViewController = day
        super.init(presentedViewController: day, presenting: nil)
    }

    // MARK: - Lifecycle
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(backgroundView)
        configureCellPresentation()
        configureBackgroundPresentation()
    }

    override func presentationTransitionDidEnd(_: Bool) {
        weekViewController.presentationAnimator.clearAdditionalAnimations()
    }

    override func dismissalTransitionWillBegin() {
        configureCellDismissal()
        configureBackgroundDismissal()
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        transition.wantsInteractiveStart = false
        weekViewController.dismissAnimator.clearAdditionalAnimations()

        if completed {
            backgroundView.removeFromSuperview()
            weekViewController.animatedCellIndex = nil
        }
    }

    // MARK: - Private
    private func configureCellPresentation() {
        guard let index = weekViewController.animatedCellIndex,
              let animatedCell = weekViewController.viewRoot.collection.cellForItem(at: index)
        else { return }

        weekViewController.presentationAnimator.add(DayDetailsAnimationsHelper.makeCellPresentationSliding(
            animatedView: animatedCell
        ))
    }

    private func configureBackgroundPresentation() {
        weekViewController.presentationAnimator.add(DayDetailsAnimationsHelper.makeBackgroundPresentation(
            animatedView: backgroundView
        ))
    }

    private func configureCellDismissal() {
        guard let index = weekViewController.animatedCellIndex,
              let animatedCell = weekViewController.viewRoot.collection.cellForItem(at: index)
        else { return }

        weekViewController.dismissAnimator.add(DayDetailsAnimationsHelper.makeCellDismissal(
            animatedView: animatedCell
        ))
    }

    private func configureBackgroundDismissal() {
        weekViewController.dismissAnimator.add(DayDetailsAnimationsHelper.makeBackgroundDismissal(
            animatedView: backgroundView
        ))
    }

    // MARK: - Events handling
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
}
