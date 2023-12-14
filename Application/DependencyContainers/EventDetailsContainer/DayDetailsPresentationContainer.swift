//
//  DayDetailsPresentationContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.12.2023.
//

import UIKit

final class DayDetailsPresentationContainer: NSObject, UIViewControllerTransitioningDelegate, ControllerFactoring {
    typealias PresentingViewController = UIViewController & DayDetailsPresentationControllerDelegate
    let presentationAnimator: DayDetailsPresentationAnimator
    let dismissAnimator: DayDetailsDismissAnimator
    let dismissTransition: UIPercentDrivenInteractiveTransition
    let parent: EventDetailsContainer
    let dayDetailsContainer: DayDetailsContainer

    var cellPresentationAnimationBlock: DayDetailsAnimationsHelper.AnimationBlock?
    var cellDismissAnimationBlock: DayDetailsAnimationsHelper.AnimationBlock?

    init(
        parent: EventDetailsContainer,
        dayDetailsContainer: DayDetailsContainer,
        presentationAnimator: DayDetailsPresentationAnimator
    ) {
        self.parent = parent
        self.dayDetailsContainer = dayDetailsContainer
        self.dismissTransition = UIPercentDrivenInteractiveTransition()
        dismissTransition.wantsInteractiveStart = false
        self.presentationAnimator = presentationAnimator
        self.dismissAnimator = DayDetailsDismissAnimator()
    }

    func make() -> UIViewController {
        let controller = dayDetailsContainer.make() as! DayDetailsViewController
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        return controller
    }

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
            presented: presented,
            presenting: parent.parent.parent.coordinator.navigationController,
            presentationAnimator: presentationAnimator,
            dismissAnimator: dismissAnimator,
            dismissTransition: dismissTransition,
            container: self
        )
    }
}
