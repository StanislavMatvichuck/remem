//
//  WeekToDayDetailsTransitioner.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.04.2023.
//

import UIKit

final class WeekToDayDetailsPresenter: NSObject {
    var animatedCellIndex: IndexPath?

    let presentationAnimator = DayDetailsPresentationAnimator()
    let dismissAnimator = DayDetailsDismissAnimator()
    let dismissTransition: UIPercentDrivenInteractiveTransition = {
        let transition = UIPercentDrivenInteractiveTransition()
        transition.wantsInteractiveStart = false
        return transition
    }()
}

// MARK: - UIViewControllerTransitioningDelegate
extension WeekToDayDetailsPresenter: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimator
    }

    func interactionControllerForDismissal(
        using animator: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        dismissTransition
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        DayDetailsPresentationController(
            week: source as! WeekViewController,
            day: presented as! DayDetailsViewController
        )
    }
}
