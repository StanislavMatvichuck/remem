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
    EventsSortingCellViewModelFactoring
{
    static let topSpacing: CGFloat = .layoutSquare / 2

    private let parent: EventsListContainer
    private var provider: EventsSortingQuerying { parent.sortingProvider }
    private var commander: EventsSortingCommanding { parent.sortingCommander }
    private var updater: ViewControllersUpdater { parent.updater }
    private var manualSortingQuerying: EventsSortingManualQuerying { parent.manualSortingProvider }
    private var manualSortingCommanding: EventsSortingManualCommanding { parent.manualSortingCommander }

    private let presentationTopOffset: CGFloat
    private let presentationAnimator = EventsSortingPresentationAnimator()
    private let dismissAnimator = EventsSortingDismissAnimator()

    init(_ parent: EventsListContainer, topOffset: CGFloat = 0) {
        self.parent = parent
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
        EventsSortingViewModel(self, manualSortingEnabled: manualSortingQuerying.get().count != 0)
    }

    func makeTapHandler() -> EventsSortingCellViewModel.TapHandler {{ selectedSorter in
        self.commander.set(selectedSorter)
    }}

    func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel {
        EventsSortingCellViewModel(
            EventsSorter.allCases[index],
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
