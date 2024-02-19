//
//  EventsListViewControllerWithDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.02.2023.
//

import Domain
import UIKit

final class EventsListViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    let factory: EventsListViewModelFactoring

    let viewRoot: EventsListView
    private let widgetUpdater: WidgetViewController
    private var timer: Timer?
    /// Needed to setup animations play only once after swipe and do not play after scroll
    private var executedEventCellsAnimations: Set<EventCellViewModel.Animations> = Set()

    var viewModel: EventsListViewModel? {
        didSet {
            executedEventCellsAnimations.removeAll()
            viewModel?.configureAnimationForEventCells(oldValue: oldValue)

            title = EventsListViewModel.title

            viewRoot.viewModel = viewModel

            guard let viewModel else { return }
            widgetUpdater.update(viewModel)

            if viewModel.shouldPresentManualSorting(oldValue),
               presentedViewController == nil
            {
                viewModel.eventsSortingHandler?(view.safeAreaInsets.top, oldValue?.sorter)
            }
        }
    }

    init(
        viewModelFactory: EventsListViewModelFactoring,
        view: EventsListView,
        widgetUpdater: WidgetViewController
    ) {
        self.factory = viewModelFactory
        self.viewRoot = view
        self.widgetUpdater = widgetUpdater
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit { timer?.invalidate() }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureList()
        setupEventsSortingButton()
        update()
        setupTimer()
    }

    private func configureList() {
        viewRoot.list.delegate = self
        viewRoot.list.dragDelegate = self
        viewRoot.list.dropDelegate = self
        viewRoot.list.dragInteractionEnabled = true
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
        viewModel?.eventsSortingHandler?(view.safeAreaInsets.top, nil)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            [weak self] _ in self?.update()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: .eventsListCellHeight)
    }
}

extension EventsListViewController: UICollectionViewDragDelegate {
    func collectionView(_: UICollectionView, itemsForBeginning _: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        dragItems(indexPath)
    }

    func dragItems(_ indexPath: IndexPath) -> [UIDragItem] {
        let eventsSection = EventsListViewModel.Section.events.rawValue
        guard indexPath.section == eventsSection else { return [] }
        let eventIndex = indexPath.row
        let provider = NSItemProvider(object: "\(eventIndex)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        viewModel?.startDragFor(eventIndex: eventIndex)
        return [dragItem]
    }

    func collectionView(_: UICollectionView, dragSessionDidEnd _: UIDragSession) {
        viewModel?.disableRemoval()
    }
}

extension EventsListViewController: UICollectionViewDropDelegate {
    func collectionView(_: UICollectionView, performDropWith _: UICollectionViewDropCoordinator) {
//        coordinator.destinationIndexPath
    }

    func collectionView(_: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath indexPath: IndexPath?) -> UICollectionViewDropProposal {
        viewRoot.updateRemovalDropAreaPosition(x: session.location(in: viewRoot).x)

        viewModel?.updateFinger(
            position: session.location(in: viewRoot).x,
            maxPosition: viewRoot.bounds.width
        )

        if indexPath?.section == EventsListViewModel.Section.events.rawValue {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .cancel)
    }
}
