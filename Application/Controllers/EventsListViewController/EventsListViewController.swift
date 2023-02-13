//
//  EventsListViewControllerWithDiffableDataSource.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.02.2023.
//

import UIKit

final class EventsListViewController: UIViewController, UITableViewDelegate {
    let viewRoot: EventsListView
    var viewModel: EventsListViewModel {
        didSet {
            guard isViewLoaded else { return }
            viewModel = connectToViewModelHandlers(viewModel: viewModel) /// does not trigger didSet
            updateUI(oldValue)
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

    // MARK: - Init
    init(viewModel: EventsListViewModel) {
        viewRoot = EventsListView()
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.viewModel = connectToViewModelHandlers(viewModel: viewModel) /// does not trigger didSet
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        updateUI(nil)
    }

    private func setupTableView() {
        let table = viewRoot.table
        table.delegate = self
        EventsListCellProvider.register(table)
    }

    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    private func updateUI(_ oldValue: EventsListViewModel?) {
        title = viewModel.title

        var newSnapshot = makeSnapshot()

        if let oldValue {
            for newItem in newSnapshot.itemIdentifiers {
                if let oldItem = oldValue.items.first(where: { $0.identifier == newItem }),
                   let newItem = viewModel.items.first(where: { $0.identifier == newItem }),
                   reconfigurationNeeded(oldItem, newItem)
                {
                    newSnapshot.reconfigureItems([newItem.identifier])
                }
            }
        }

        dataSource.apply(newSnapshot, animatingDifferences: oldValue != nil)

        if let renamedItem = viewModel.renamedItem {
            viewRoot.input.rename(oldName: renamedItem.name)
        } else if viewModel.inputVisible {
            viewRoot.input.show(value: viewModel.inputContent)
        }
    }

    private func reconfigurationNeeded<
        T: EventsListItemViewModeling,
        U: EventsListItemViewModeling
    >(_ lhs: T, _ rhs: U) -> Bool {
        type(of: lhs) == type(of: rhs) &&
            lhs.identifier == rhs.identifier &&
            lhs.self != rhs.self as? T
    }

    private func makeSnapshot() -> NSDiffableDataSourceSnapshot<Int, String> {
        let itemsIDs = viewModel.items.map { $0.identifier }

        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(itemsIDs)
        return snapshot
    }

    @objc private func handleAdd() {
        if let renamedEventItem = viewModel.renamedItem {
            renamedEventItem.rename(to: viewRoot.input.value)
        } else {
            viewModel.add(name: viewRoot.input.value)
        }
    }

    /// - Parameter viewModel: all handlers of this vm will be updated to
    /// - Parameter controller: self that plays multiple roles by extensions in viewModels files
    /// - Returns: new version of list view model with all handlers configured to call controller
    private func connectToViewModelHandlers(viewModel: EventsListViewModel) -> EventsListViewModel {
        var newViewModel = viewModel

        for (i, item) in newViewModel.items.enumerated() {
            if let vm = item as? FooterItemViewModel {
                newViewModel.items[i] = vm.withSelectionHandler(self)
            }

            if let vm = item as? EventItemViewModel {
                newViewModel.items[i] = vm.withRenameHandler(self)
            }
        }

        return newViewModel
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

extension EventsListViewController: FooterItemViewModelResponding {
    func selected(_: FooterItemViewModel) {
        viewModel.showInput()
    }
}

extension EventsListViewController: EventItemViewModelRenameResponding {
    func renameRequested(_ itemViewModel: EventItemViewModel) {
        viewModel.renamedItem = itemViewModel
    }
}
