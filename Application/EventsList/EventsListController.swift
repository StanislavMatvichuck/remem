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

    var viewModel: EventsListViewModel? { didSet {
        title = EventsListViewModel.title

        viewRoot.viewModel = viewModel

        guard let viewModel else { return }

        if viewModel.manualSortingPresentableFor(oldValue),
           presentedViewController == nil
        {
            showEventsOrderingService?.serve(ShowEventsOrderingServiceArgument(offset: view.safeAreaInsets.top, oldValue: oldValue?.ordering))
        }

        /// This is here to trigger widget update on each list update because controller is subscribed to DomainEvents
        widgetService?.serve(ApplicationServiceEmptyArgument())
    } }

    private let widgetService: WidgetService?
    private let showEventsOrderingService: ShowEventsOrderingService?
    private let setEventsOrderingService: SetEventsOrderingService?
    private var timer: Timer?

    private var eventsListOrderingSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var happeningCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var happeningDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var eventRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var eventCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var eventVisitedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var goalCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var goalDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    private var goalUpdatedSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        viewModelFactory: EventsListViewModelFactoring,
        view: EventsListView,
        showEventsOrderingService: ShowEventsOrderingService? = nil,
        setEventsOrderingService: SetEventsOrderingService? = nil,
        widgetService: WidgetService? = nil
    ) {
        self.factory = viewModelFactory
        self.showEventsOrderingService = showEventsOrderingService
        self.setEventsOrderingService = setEventsOrderingService
        self.viewRoot = view
        self.widgetService = widgetService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError(errorUIKitInit) }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewRoot.startHintAnimationIfNeeded()
    }

    deinit {
        timer?.invalidate()
        timer = nil
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
        configureEventsSortingButton()
        update()
        configureTimer()
        configureForegroundNotification()
        configureDomainEventsSubscriptions()
    }

    // MARK: - Events handling

    @objc private func handleForeground() { viewRoot.startHintAnimationIfNeeded() }
    @objc private func handleEventsSortingTap() {
        showEventsOrderingService?.serve(ShowEventsOrderingServiceArgument(
            offset: view.safeAreaInsets.top,
            oldValue: nil
        ))
    }

    func handle(manualOrdering eventsIdentifiers: [String]) {
        setEventsOrderingService?.serve(SetEventsOrderingServiceArgument(
            eventsIdentifiersOrder: eventsIdentifiers,
            ordering: .manual
        ))
    }

    // MARK: - Private configurations

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

    private func configureEventsSortingButton() {
        let item = UIBarButtonItem(
            title: EventsListViewModel.eventsSortingLabel,
            style: .plain, target: self,
            action: #selector(handleEventsSortingTap)
        )
        navigationItem.setRightBarButton(item, animated: false)
    }

    private func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            [weak self] _ in self?.update()
        }
    }
}
