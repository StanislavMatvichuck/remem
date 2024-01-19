//
//  EventsSortingPresentationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import UIKit

final class EventsSortingPresentationController: UIPresentationController {
    let topOffset: CGFloat
    lazy var background: UIView = {
        let view = UIView(frame: containerView?.bounds ?? .zero)
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapHandler)
        return view
    }()

    init(presentedViewController: UIViewController, presenting: UIViewController?, topOffset: CGFloat = 0) {
        self.topOffset = topOffset
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerWidth = containerView?.bounds.width ?? UIScreen.main.bounds.width
        let finalWidth = containerWidth * 0.4
        let finalHeight = 3 * .buttonHeight
        let newSize = CGRect(
            origin: CGPoint(
                x: containerWidth - finalWidth,
                y: topOffset
            ),
            size: CGSize(
                width: finalWidth,
                height: finalHeight
            )
        )

        return newSize
    }

    // MARK: - Lifecycle
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(background)
    }

    // MARK: - Events handling
    @objc private func handleTap() { presentingViewController.dismiss(animated: true) }
}
