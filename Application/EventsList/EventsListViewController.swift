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

    var viewModel: EventsListViewModel? {
        didSet {
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
