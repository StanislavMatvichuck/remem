//
//  EventsListViewControllerWithDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.02.2023.
//

import Domain
import UIKit

final class EventsListController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    EventsListDataProviding
{
    let factory: EventsListViewModelFactoring

    let viewRoot: EventsListView
    private var timer: Timer?

    var viewModel: EventsListViewModel? {
        didSet {
            title = EventsListViewModel.title

            viewRoot.viewModel = viewModel

            guard let viewModel else { return }

            if viewModel.manualSortingPresentableFor(oldValue),
               presentedViewController == nil
            {
                showEventsOrderingService?.serve(ShowEventsOrderingServiceArgument(offset: view.safeAreaInsets.top, oldValue: oldValue?.ordering))
            }
        }
    }

    var showEventsOrderingService: ShowEventsOrderingService?
    var setEventsOrderingService: SetEventsOrderingService?

    var eventsListOrderingSubscription: DomainEventsPublisher.DomainEventSubscription?
    var happeningCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var happeningDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var eventRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var eventCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var eventVisitedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalUpdatedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        viewModelFactory: EventsListViewModelFactoring,
        view: EventsListView,
        showEventsOrderingService: ShowEventsOrderingService? = nil,
        setEventsOrderingService: SetEventsOrderingService? = nil
    ) {
        self.factory = viewModelFactory
        self.showEventsOrderingService = showEventsOrderingService
        self.setEventsOrderingService = setEventsOrderingService
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewRoot.startHintAnimationIfNeeded()
    }

    deinit {
        timer?.invalidate()
        eventsListOrderingSubscription = nil
        happeningCreatedSubscription = nil
        happeningDeletedSubscription = nil
        eventRemovedSubscription = nil
        eventCreatedSubscription = nil
        eventVisitedSubscription = nil
        goalCreatedSubscription = nil
        goalDeletedSubscription = nil
        goalUpdatedSubscription = nil
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureList()
        setupEventsSortingButton()
        update()
        setupTimer()
        configureForegroundNotification()
        configureDomainEventsSubscriptions()
    }

    private func configureDomainEventsSubscriptions() {
        eventsListOrderingSubscription = DomainEventsPublisher.shared.subscribe(
            EventsListOrderingSet.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        eventRemovedSubscription = DomainEventsPublisher.shared.subscribe(
            EventRemoved.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        eventCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            EventCreated.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        eventVisitedSubscription = DomainEventsPublisher.shared.subscribe(
            EventVisited.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        happeningCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningCreated.self,
            usingBlock: { [weak self] action in
                self?.update()
                if let renderedCells = self?.viewRoot.list.visibleCells {
                    for cell in renderedCells {
                        if let cell = cell as? EventCell, cell.viewModel?.vm?.id == action.eventId {
                            cell.playSwipeAnimation()
                        }
                    }
                }
            }
        )

        happeningDeletedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningRemoved.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        goalCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalCreated.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        goalDeletedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalDeleted.self,
            usingBlock: { [weak self] _ in self?.update() }
        )

        goalUpdatedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalValueUpdated.self,
            usingBlock: { [weak self] _ in self?.update() }
        )
    }

    private func configureList() {
        viewRoot.list.dragDelegate = self
        viewRoot.list.dropDelegate = self
        viewRoot.list.dragInteractionEnabled = true
        viewRoot.dataSource.viewModelProvider = self
    }

    private func configureForegroundNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleForeground),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc private func handleForeground() {
        viewRoot.startHintAnimationIfNeeded()
    }

    private func setupEventsSortingButton() {
        let item = UIBarButtonItem(
            title: EventsListViewModel.eventsSortingLabel,
            style: .plain, target: self,
            action: #selector(handleEventsSortingTap)
        )
        navigationItem.setRightBarButton(item, animated: false)
    }

    @objc private func handleEventsSortingTap() {
        showEventsOrderingService?.serve(ShowEventsOrderingServiceArgument(offset: view.safeAreaInsets.top, oldValue: nil))
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            [weak self] _ in self?.update()
        }
    }
}
