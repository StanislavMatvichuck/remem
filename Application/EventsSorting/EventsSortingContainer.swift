//
//  EventsSortingContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

import DataLayer
import Domain
import UIKit

final class EventsSortingContainer:
    NSObject,
    EventsSortingViewModelFactoring,
    EventsSortingCellViewModelFactoring,
    EventsOrderingControllerFactoring
{
    static let topSpacing: CGFloat = .layoutSquare / 2

    private let parent: EventsListContainer
    private var animateFrom: EventsList.Ordering?
    private var provider: EventsOrderingReading { parent.sortingProvider }
    private var commander: EventsOrderingWriting { parent.sortingCommander }
    private var manualSortingQuerying: ManualEventsOrderingReading { parent.manualSortingProvider }
    private var manualSortingCommanding: ManualEventsOrderingWriting { parent.manualSortingCommander }

    private var presentationTopOffset: CGFloat
    private let presentationAnimator = EventsSortingPresentationAnimator()
    private let dismissAnimator = EventsSortingDismissAnimator()

    init(
        _ parent: EventsListContainer,
        topOffset: CGFloat = 0,
        animateFrom: EventsList.Ordering? = nil
    ) {
        self.parent = parent
        self.animateFrom = animateFrom
        self.presentationTopOffset = topOffset
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
            EventsList.Ordering.allCases[index],
            activeSorter: provider.get()
        )
    }

    func makeEventsOrderingController(using arg: ShowEventsOrderingServiceArgument) -> EventsSortingController {
        animateFrom = arg.oldValue
        presentationTopOffset = arg.offset
        let view = EventsSortingView(service: makeSetEventsOrderingService())
        let controller = EventsSortingController(self, view: view)
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        return controller
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
