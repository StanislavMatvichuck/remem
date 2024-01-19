//
//  EventsSortingPresentationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import UIKit

final class EventsSortingPresentationController: UIPresentationController {
    let topOffset: CGFloat

    init(presentedViewController: UIViewController, presenting: UIViewController?, topOffset: CGFloat = 0) {
        self.topOffset = topOffset
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerWidth = containerView?.bounds.width ?? UIScreen.main.bounds.width
        let finalWidth = containerWidth / 3
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
}
