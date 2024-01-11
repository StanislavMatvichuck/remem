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
    var dataSource: EventsListDataSource!
    let widgetUpdater: WidgetViewController
    var timer: Timer?

    var viewModel: EventsListViewModel! {
        didSet {
            guard isViewLoaded else { return }

            title = EventsListViewModel.title

            if let oldValue { viewModel = viewModel.configureAnimationForEventCells(oldValue) }

            dataSource.update(viewModel, oldValue)
            viewRoot.configureContent(viewModel)
            widgetUpdater.update(viewModel)
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
        self.dataSource = EventsListDataSource(
            tableView: view.table,
            cellProvider: { [weak self] table, indexPath, identifier in
                guard let self, let viewModel = self.viewModel.cellAt(identifier: identifier)
                else { fatalError("data source unable to use its provider") }
                return EventsListDataSource.cell(
                    table: table,
                    forIndex: indexPath,
                    viewModel: viewModel
                )
            }
        )
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit { timer?.invalidate() }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        update()
        setupTimer()
    }

    private func setupTableView() {
        let table = viewRoot.table
        table.delegate = self
        table.dragDelegate = self
        dataSource.register(table)
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

        if let renamedEventItem = viewModel.renamedItem {
            renamedEventItem.rename(to: viewRoot.input.value)
        } else {
            viewModel.addHandler(viewRoot.input.value)
        }
    }

    func tableView(_ table: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = table.cellForRow(at: indexPath) as! TrailingSwipeActionsConfigurationProviding
        return cell.trailingActionsConfiguration()
    }
}

extension EventsListViewController:
    EventItemViewModelRenameHandling,
    FooterItemViewModelTapHandling
{
    func renameTapped(_ item: EventCellViewModel) {
        viewModel.renamedItem = item
    }

    func tapped(_: FooterCellViewModel) {
        viewModel.showInput()
    }
}

extension EventsListViewController: UITableViewDragDelegate {
    func tableView(
        _: UITableView,
        itemsForBeginning _: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard viewModel.isEventAt(index: indexPath.row) else { return [] }
        let provider = NSItemProvider(object: "\(indexPath.row)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }
}
