//
//  DayDetailsPresentationContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.12.2023.
//

import UIKit

final class DayDetailsPresentationContainer:
    NSObject,
    UIViewControllerTransitioningDelegate,
    DayDetailsControllerFactoring
{
    typealias PresentingViewController = UIViewController & DayDetailsPresentationControllerDelegate
    let presentationAnimator: DayDetailsPresentationAnimator
    let dismissAnimator: DayDetailsDismissAnimator
    let dismissTransition: UIPercentDrivenInteractiveTransition
    let parent: EventDetailsContainer
    var navigationController: UINavigationController { parent.parent.coordinator.navigationController }

    var cellPresentationAnimationBlock: DayDetailsAnimationsHelper.AnimationBlock?
    var cellDismissAnimationBlock: DayDetailsAnimationsHelper.AnimationBlock?

    init(parent: EventDetailsContainer) {
        self.parent = parent
        self.dismissTransition = UIPercentDrivenInteractiveTransition()
        dismissTransition.wantsInteractiveStart = false
        self.presentationAnimator = DayDetailsPresentationAnimator()
        self.dismissAnimator = DayDetailsDismissAnimator()
    }

    func makeDayDetailsController(_ arg: ShowDayDetailsServiceArgument) -> DayDetailsViewController {
        cellPresentationAnimationBlock = arg.presentationAnimation
        cellDismissAnimationBlock = arg.dismissAnimation
        let controller = DayDetailsContainer(parent, startOfDay: arg.startOfDay).make() as! DayDetailsViewController
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
            presenting: navigationController,
            presentationAnimator: presentationAnimator,
            dismissAnimator: dismissAnimator,
            dismissTransition: dismissTransition,
            container: self
        )
    }
}
