//
//  DetailsPresentationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.04.2023.
//

import UIKit

final class DayDetailsPresentationController: UIPresentationController {
    weak var presentationDelegate: (AnyObject & DayDetailsPresentationControllerDelegate)?

    let presentationAnimator: DayDetailsPresentationAnimator
    let dismissAnimator: DayDetailsDismissAnimator
    let dismissTransition: UIPercentDrivenInteractiveTransition
    let container: DayDetailsPresentationContainer

    lazy var backgroundView: UIView = {
        let dayDetailsBackground = UIView(frame: CGRect(
            x: frameOfPresentedViewInContainerView.minX,
            y: DayDetailsPresentationAnimator.originHeight,
            width: frameOfPresentedViewInContainerView.width,
            height: frameOfPresentedViewInContainerView.height
        ))
        dayDetailsBackground.backgroundColor = .border
        dayDetailsBackground.layer.cornerRadius = .buttonMargin

        let backgroundView = UIView(frame: containerView!.frame)
        backgroundView.backgroundColor = .bg
        backgroundView.alpha = 0

        backgroundView.addSubview(dayDetailsBackground)
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

    init(
        presented: UIViewController,
        presenting: UIViewController?,
        presentationAnimator: DayDetailsPresentationAnimator,
        dismissAnimator: DayDetailsDismissAnimator,
        dismissTransition: UIPercentDrivenInteractiveTransition,
        container: DayDetailsPresentationContainer
    ) {
        self.presentationAnimator = presentationAnimator
        self.dismissAnimator = dismissAnimator
        self.dismissTransition = dismissTransition
        self.container = container
        super.init(presentedViewController: presented, presenting: presenting)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let relativeWidth: CGFloat = 0.66666
        let width: CGFloat = .screenW * relativeWidth

        let leftMargin: CGFloat = (.screenW - width) / 2
        let height = width * 1.6

        return CGRect(
            x: leftMargin,
            y: containerView?.frame.maxY ?? 0,
            width: width,
            height: height
        )
    }

    // MARK: - Lifecycle
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(backgroundView)
        configureCellPresentation()
        configureBackgroundPresentation()
    }

    override func presentationTransitionDidEnd(_: Bool) {
        presentationAnimator.clearAdditionalAnimations()
    }

    override func dismissalTransitionWillBegin() {
        configureCellDismissal()
        configureBackgroundDismissal()
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        dismissTransition.wantsInteractiveStart = false
        dismissAnimator.clearAdditionalAnimations()

        if completed {
            backgroundView.removeFromSuperview()
            presentationDelegate?.dismissCompleted()
        }
    }

    // MARK: - Private
    private func configureCellPresentation() {
        guard let cellPresentationAnimationBlock = container.cellPresentationAnimationBlock else { return }
        presentationAnimator.add(cellPresentationAnimationBlock)
    }

    private func configureBackgroundPresentation() {
        presentationAnimator.add(DayDetailsAnimationsHelper.makeBackgroundPresentation(
            animatedView: backgroundView
        ))
    }

    private func configureCellDismissal() {
        guard let cellDismissAnimationBlock = container.cellDismissAnimationBlock else { return }
        dismissAnimator.add(cellDismissAnimationBlock)
    }

    private func configureBackgroundDismissal() {
        dismissAnimator.add(DayDetailsAnimationsHelper.makeBackgroundDismissal(
            animatedView: backgroundView
        ))
    }

    // MARK: - Events handling
    @objc func handle(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view else { return }

        let verticalOffset = pan.translation(in: view).y
        let progress = max(0.0, min(1.0, verticalOffset / 300))

        if pan.state == .began {
            dismissTransition.wantsInteractiveStart = true
            presentingViewController.dismiss(animated: true)
        } else if pan.state == .changed {
            dismissTransition.update(progress)
        } else if pan.state == .ended {
            if progress >= 0.5 {
                dismissTransition.finish()
            } else {
                dismissTransition.cancel()
            }
        }
    }

    @objc func handleTap(_: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
