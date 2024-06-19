//
//  WeekCircleController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.06.2024.
//

import Domain
import UIKit

protocol WeekCircleViewModelFactoring { func makeViewModel() -> WeekCircleViewModel }

final class WeekCircleController: UIViewController {
    private let viewRoot: WeekCircleView
    private let viewModelFactory: WeekCircleViewModelFactoring
    private var viewModel: WeekCircleViewModel { didSet {
        viewRoot.viewModel = viewModel
    }}

    private var happeningCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var happeningRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        view: WeekCircleView,
        viewModel: WeekCircleViewModel,
        viewModelFactory: WeekCircleViewModelFactoring)
    {
        self.viewRoot = view
        self.viewModel = viewModel
        self.viewModelFactory = viewModelFactory
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
