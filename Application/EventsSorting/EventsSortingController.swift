//
//  EventsSortingController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

import Domain
import Foundation
import UIKit

final class EventsSortingController: UIViewController {
    // MARK: - Properties
    let viewRoot: EventsSortingView
    let factory: EventsSortingViewModelFactoring

    var viewModel: EventsSortingViewModel? { didSet {
        guard let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    private var subscription: DomainEventsPublisher.DomainEventSubscription?

    // MARK: - Init
    init(_ factory: EventsSortingViewModelFactoring, view: EventsSortingView) {
        self.factory = factory
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeEventsSortingViewModel()
        subscription = DomainEventsPublisher.shared.subscribe(EventsListOrderingSet.self, usingBlock: { [weak self] _ in
            self?.update()
        })
    }

    deinit { subscription = nil }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateToManualWithDismissIfNeeded()
    }

    // MARK: - Private
    private func animateToManualWithDismissIfNeeded() {
        guard let viewModel, viewModel.animateFrom != nil else { return }

        viewRoot.animateSelectionBackground(to: viewModel.activeSorterIndex) {
            self.dismiss(animated: true)
        }
    }
}
