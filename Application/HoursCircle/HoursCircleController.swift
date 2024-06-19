//
//  HoursCircleController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

import Domain
import UIKit

protocol HoursCircleViewModelFactoring { func makeViewModel() -> HoursCircleViewModel }

final class HoursCircleController: UIViewController {
    private let viewRoot: HoursCircleView
    private let viewModelFactory: HoursCircleViewModelFactoring
    private var viewModel: HoursCircleViewModel { didSet {
        viewRoot.viewModel = viewModel
    }}

    private var happeningCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var happeningRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        view: HoursCircleView,
        viewModel: HoursCircleViewModel,
        viewModelFactory: HoursCircleViewModelFactoring)
    {
        self.viewRoot = view
        self.viewModelFactory = viewModelFactory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDomainEventsSubscriptions()
    }

    // MARK: - Private

    private func configureDomainEventsSubscriptions() {
        happeningCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningCreated.self,
            usingBlock: { [weak self] _ in
                guard let self else { return }
                self.viewModel = self.viewModelFactory.makeViewModel()
            })

        happeningRemovedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningRemoved.self,
            usingBlock: { [weak self] _ in
                guard let self else { return }
                self.viewModel = self.viewModelFactory.makeViewModel()
            })
    }
}
