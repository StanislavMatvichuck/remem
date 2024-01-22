//
//  EventsListViewControllerWithDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.02.2023.
//

import UIKit

final class EventsListViewController: UIViewController, UITableViewDelegate {
    let factory: EventsListViewModelFactoring
    let viewRoot: EventsListView
    let widgetUpdater: WidgetViewController
    var timer: Timer?

    var viewModel: EventsListViewModel? {
        didSet {
            guard isViewLoaded else { return }
            title = EventsListViewModel.title
            viewRoot.viewModel = viewModel
            guard let viewModel else { return }
            widgetUpdater.update(viewModel)

            if viewModel.shouldPresentManualSorting(oldValue),
               presentedViewController == nil
            { handleEventsSortingTap(autoDismiss: true) }
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
        setupTableView()
        setupEventHandlers()
        setupEventsSortingButton()
        update()
        setupTimer()
    }

    private func setupTableView() {
        let table = viewRoot.table
        table.delegate = self
        table.dragDelegate = self
        table.dropDelegate = self
        table.dragInteractionEnabled = true
    }

    private func setupEventsSortingButton() {
        let item = UIBarButtonItem(
            title: EventsListViewModel.eventsSortingLabel,
            style: .plain, target: self,
            action: #selector(handleEventsSortingTap)
        )
        navigationItem.setRightBarButton(item, animated: false)
    }

    @objc private func handleEventsSortingTap(autoDismiss: Bool = false) {
        viewModel?.eventsSortingHandler(view.safeAreaInsets.top, autoDismiss)
    }

    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) {
            [weak self] _ in self?.update()
        }
    }

    @objc private func handleAdd() {
        guard !viewRoot.input.value.isEmpty else { return }

        if let renamedEventItem = viewModel?.renamedItem {
            renamedEventItem.rename(to: viewRoot.input.value)
        } else {
            viewModel?.addHandler(viewRoot.input.value)
        }
    }
}

extension EventsListViewController:
    EventItemViewModelRenameHandling,
    FooterItemViewModelTapHandling
{
    func renameTapped(_ item: EventCellViewModel) {
        viewModel?.renamedItem = item
    }

    func tapped(_: FooterCellViewModel) {
        viewModel?.showInput()
    }
}

extension EventsListViewController: UITableViewDragDelegate {
    func tableView(
        _: UITableView,
        itemsForBeginning _: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] { dragItems(for: indexPath) }

    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let eventsSection = EventsListViewModel.Section.events.rawValue
        guard indexPath.section == eventsSection else { return [] }

        let provider = NSItemProvider(object: "\(indexPath.row)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }
}

extension EventsListViewController: UITableViewDropDelegate {
    func tableView(_: UITableView, performDropWith _: UITableViewDropCoordinator) {}
    func tableView(
        _: UITableView,
        dropSessionDidUpdate _: UIDropSession,
        withDestinationIndexPath indexPath: IndexPath?
    ) -> UITableViewDropProposal {
        if indexPath?.section == EventsListViewModel.Section.events.rawValue {
            UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            UITableViewDropProposal(operation: .forbidden)
        }
    }
}
