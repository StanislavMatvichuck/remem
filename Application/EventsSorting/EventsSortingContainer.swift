//
//  EventsSortingContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

import DataLayer
import Domain
import UIKit

final class EventsSortingContainer: NSObject,
    ControllerFactoring,
    EventsSortingViewModelFactoring,
    EventsSortingCellViewModelFactoring,
    EventsOrderingControllerFactoring
{
    static let topSpacing: CGFloat = .layoutSquare / 2

    private let parent: EventsListContainer
    private var animateFrom: EventsSorter?
    private var provider: EventsSortingQuerying { parent.sortingProvider }
    private var commander: EventsSortingCommanding { parent.sortingCommander }
    private var updater: ViewControllersUpdater { parent.updater }
    private var manualSortingQuerying: EventsSortingManualQuerying { parent.manualSortingProvider }
    private var manualSortingCommanding: EventsSortingManualCommanding { parent.manualSortingCommander }

    private var presentationTopOffset: CGFloat
    private let presentationAnimator = EventsSortingPresentationAnimator()
    private let dismissAnimator = EventsSortingDismissAnimator()

    init(
        _ parent: EventsListContainer,
        topOffset: CGFloat = 0,
        animateFrom: EventsSorter? = nil
    ) {
        self.parent = parent
        self.animateFrom = animateFrom
        self.presentationTopOffset = topOffset
    }

    func make() -> UIViewController {
        let view = EventsSortingView(factory: parent)
        let controller = EventsSortingController(self, view: view)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        updater.addDelegate(controller)
        return controller
    }

    func makeEventsSortingViewModel() -> EventsSortingViewModel {
        EventsSortingViewModel(
            self,
            manualSortingEnabled: manualSortingQuerying.get().count != 0,
            activeSorterIndex: provider.get().rawValue,
            animateFrom: animateFrom
        )
    }

    func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel {
        EventsSortingCellViewModel(
            EventsSorter.allCases[index],
            activeSorter: provider.get()
        )
    }

    func makeEventsOrderingController(using arg: ShowEventsOrderingServiceArgument) -> EventsSortingController {
        animateFrom = arg.oldValue
        presentationTopOffset = arg.offset
        return make() as! EventsSortingController
    }

    func makeSetEventsOrderingService() -> SetEventsOrderingService {
        parent.makeSetEventsOrderingService()
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
            topOffset: presentationTopOffset + Self.topSpacing,
            cellsCount: makeEventsSortingViewModel().count
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
