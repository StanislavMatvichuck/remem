//
//  EventsSortingContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

import Domain
import UIKit

final class EventsSortingContainer: NSObject,
    ControllerFactoring,
    EventsSortingViewModelFactoring
{
    private let provider: EventsSortingQuerying
    private let presentationTopOffset: CGFloat
    private let presentationAnimator = EventsSortingPresentationAnimator()
    private let dismissAnimator = EventsSortingDismissAnimator()

    init(_ provider: EventsSortingQuerying, topOffset: CGFloat = 0) {
        self.provider = provider
        self.presentationTopOffset = topOffset
    }

    func make() -> UIViewController {
        let controller = EventsSortingController(self)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        return controller
    }

    func makeEventsSortingViewModel() -> EventsSortingViewModel {
        EventsSortingViewModel(provider.get())
    }
}

extension EventsSortingContainer: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        EventsSortingPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            topOffset: presentationTopOffset
        )
    }

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        dismissAnimator
    }
}
