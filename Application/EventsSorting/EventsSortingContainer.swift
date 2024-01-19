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
    UIViewControllerTransitioningDelegate,
    EventsSortingViewModelFactoring
{
    private let provider: EventsSortingQuerying

    init(provider: EventsSortingQuerying) { self.provider = provider }

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
