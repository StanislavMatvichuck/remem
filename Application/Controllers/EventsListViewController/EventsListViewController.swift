//
//  EventsListViewControllerWithDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.02.2023.
//

import UIKit

typealias EventsListViewModelHandling =
    EventItemViewModelRenameHandling &
    FooterItemViewModelTapHandling

protocol EventsListViewModelFactoring {
    func makeEventsListViewModel(_: EventsListViewModelHandling?) -> EventsListViewModel
}

final class EventsListViewController: UIViewController, UITableViewDelegate {
    let factory: EventsListViewModelFactoring
    let viewRoot: EventsListView
    let widgetUpdater: WidgetViewController
    let watcher: Watching

    var viewModel: EventsListViewModel! {
        didSet {
            guard isViewLoaded else { return }

            title = viewModel.title

            dataSource.update(viewModel.items, oldValue)

            if let renamedItem = viewModel.renamedItem {
                viewRoot.input.rename(oldName: renamedItem.name)
            } else if viewModel.inputVisible {
                viewRoot.input.show(value: viewModel.inputContent)
            }

            widgetUpdater.update(
                viewModel.items.filter { type(of: $0) is EventItemViewModel.Type }
                    as! [EventItemViewModel]
            )
        }
    }

    lazy var dataSource: EventsListDataSource = {
        EventsListDataSource(
            tableView: viewRoot.table,
            cellProvider: { table, indexPath, identifier in
                let index = self.viewModel[identifier]!
                let viewModel = self.viewModel.items[index]
                return EventsListCellProvider.cell(
                    table: table,
                    forIndex: indexPath,
                    viewModel: viewModel
                )
            }
        )
    }()

    init(
        _ factory: EventsListViewModelFactoring,
        _ watcher: Watching
    ) {
        self.factory = factory
        self.watcher = watcher

        self.viewRoot = EventsListView()
        self.widgetUpdater = WidgetViewController()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        update()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        watcher.watch(.now)
    }

    private func setupTableView() {
        let table = viewRoot.table
        table.delegate = self
        EventsListCellProvider.register(table)
    }

    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    @objc private func handleAdd() {
        if let renamedEventItem = viewModel.renamedItem {
            renamedEventItem.rename(to: viewRoot.input.value)
        } else {
            viewModel.add(name: viewRoot.input.value)
        }
    }

    func tableView(_ table: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let viewModel = viewModel.items[indexPath.row]
        let cell = EventsListCellProvider.cell(
            table: table,
            forIndex: indexPath,
            viewModel: viewModel
        )
        guard let cellWithConfiguration = cell as? TrailingSwipeActionsConfigurationProviding else { return nil }
        return cellWithConfiguration.trailingActionsConfiguration()
    }
}

extension EventsListViewController:
    EventItemViewModelRenameHandling,
    FooterItemViewModelTapHandling
{
    func renameTapped(_ item: EventItemViewModel) {
        viewModel.renamedItem = item
    }

    func tapped(_: FooterItemViewModel) {
        viewModel.showInput()
    }
}
