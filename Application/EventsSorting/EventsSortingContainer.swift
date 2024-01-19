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
    EventsSortingViewModelFactoring,
    EventsSortingCellViewModelFactoring
{
    static let topSpacing: CGFloat = .layoutSquare / 2

    private let provider: EventsSortingQuerying
    private let commander: EventsSortingCommanding
    private let updater: ViewControllersUpdater
    private let presentationTopOffset: CGFloat
    private let presentationAnimator = EventsSortingPresentationAnimator()
    private let dismissAnimator = EventsSortingDismissAnimator()

    init(
        provider: EventsSortingQuerying,
        commander: EventsSortingCommanding,
        updater: ViewControllersUpdater,
        topOffset: CGFloat = 0
    ) {
        self.provider = provider
        self.commander = commander
        self.updater = updater
        self.presentationTopOffset = topOffset
    }

    func make() -> UIViewController {
        let controller = EventsSortingController(self)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        updater.addDelegate(controller)
        return controller
    }

    func makeEventsSortingViewModel() -> EventsSortingViewModel {
        EventsSortingViewModel(self)
    }

    func makeTapHandler() -> EventsSortingCellViewModel.TapHandler {{ selectedSorter in
        self.commander.set(selectedSorter)
    }}

    func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel {
        let sorters = EventsSorter.allCases
        return EventsSortingCellViewModel(
            sorters[index],
            activeSorter: provider.get(),
            handler: makeTapHandler()
        )
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
            topOffset: presentationTopOffset + Self.topSpacing
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
