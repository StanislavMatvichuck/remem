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

    var backgroundGradientLayer: CAGradientLayer?
    var backgroundBorderLayer: CALayer?

    lazy var backgroundView: UIView = {
        let borderWidth = DayDetailsView.margin * 3
        let dayDetailsLeftOffset = frameOfPresentedViewInContainerView.minX - borderWidth / 2
        let dayDetailsTopOffset = frameOfPresentedViewInContainerView.minY - borderWidth / 2
        let dayDetailsBackgroundWidth = frameOfPresentedViewInContainerView.width + borderWidth
        let dayDetailsBackgroundHeight = frameOfPresentedViewInContainerView.height + borderWidth
        let dayDetailsBackground = UIView(frame: CGRect(
            x: dayDetailsLeftOffset,
            y: dayDetailsTopOffset,
            width: dayDetailsBackgroundWidth,
            height: dayDetailsBackgroundHeight
        ))
        dayDetailsBackground.backgroundColor = .remem_border
        dayDetailsBackground.layer.cornerRadius = DayDetailsView.radius
        dayDetailsBackground.layer.borderColor = UIColor.remem_border.cgColor
        dayDetailsBackground.layer.borderWidth = borderWidth
        dayDetailsBackground.clipsToBounds = false
        self.backgroundBorderLayer = dayDetailsBackground.layer

        let shapeLayer = CAGradientLayer()
        shapeLayer.frame = CGRect(
            x: dayDetailsLeftOffset,
            y: dayDetailsBackground.frame.maxY - borderWidth,
            width: dayDetailsBackgroundWidth,
            height: containerView!.frame.maxY - dayDetailsBackground.frame.maxY
        )
        shapeLayer.type = .axial
        shapeLayer.startPoint = CGPoint(x: 0, y: 0)
        shapeLayer.endPoint = CGPoint(x: 0, y: 1)
        shapeLayer.colors = [UIColor.remem_border.cgColor, UIColor.remem_bg.cgColor]
        self.backgroundGradientLayer = shapeLayer

        let backgroundView = UIView(frame: containerView!.frame)
        backgroundView.backgroundColor = .remem_bg
        backgroundView.alpha = 0
        backgroundView.isAccessibilityElement = true
        backgroundView.accessibilityIdentifier = UITestID.dayDetailsBackground.rawValue
        backgroundView.addSubview(dayDetailsBackground)
        backgroundView.layer.addSublayer(shapeLayer)
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
        if #available(iOS 17.0, *) { registerForTraitChanges([UITraitUserInterfaceStyle.self], target: self, action: #selector(updateBackgroundColors)) }
    }

    @objc private func updateBackgroundColors() {
        backgroundGradientLayer?.colors = [UIColor.remem_border.cgColor, UIColor.remem_bg.cgColor]
        backgroundBorderLayer?.borderColor = UIColor.remem_border.cgColor
    }

    lazy var detailsViewCalculatedRect = {
        let relativeWidth: CGFloat = 2 / 3
        let width: CGFloat = .screenW * relativeWidth
        let container = UIView(frame: containerView!.bounds)

        // TODO: simplify this?
        let detailsView = DayDetailsView(list: DayDetailsView.makeList(), viewModel: DayDetailsViewModel(currentMoment: .now, startOfDay: .now, pickerDate: nil, cells: [], eventId: ""))
        detailsView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(detailsView)
        detailsView.widthAnchor.constraint(equalToConstant: width).isActive = true
        detailsView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        detailsView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true

        detailsView.layoutIfNeeded()
        container.layoutIfNeeded()

        return detailsView.frame
    }()

    override var frameOfPresentedViewInContainerView: CGRect {
        detailsViewCalculatedRect
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
