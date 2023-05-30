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
    var dataSource: EventsListDataSource!
    let widgetUpdater: WidgetViewController
    let cellAnimator: AnimatingHappeningCreation
    var timer: Timer?

    var viewModel: EventsListViewModel! {
        didSet {
            guard isViewLoaded else { return }

            title = EventsListViewModel.title

            dataSource.update(viewModel.items, oldValue)

            if let renamedItem = viewModel.renamedItem {
                viewRoot.input.rename(oldName: renamedItem.title)
            } else if viewModel.inputVisible {
                viewRoot.input.show(value: viewModel.inputContent)
            }

            widgetUpdater.update(viewModel.items.filter { type(of: $0) is EventCellViewModel.Type } as! [EventCellViewModel])
        }
    }

    init(
        viewModelFactory: EventsListViewModelFactoring,
        view: EventsListView,
        widgetUpdater: WidgetViewController,
        cellAnimator: AnimatingHappeningCreation
    ) {
        self.factory = viewModelFactory
        self.viewRoot = view
        self.widgetUpdater = widgetUpdater
        self.cellAnimator = cellAnimator
        super.init(nibName: nil, bundle: nil)
        self.dataSource = EventsListDataSource(
            tableView: view.table,
            cellProvider: { [weak self] table, indexPath, identifier in
                guard let self else { fatalError() }

                let index = self.viewModel[identifier]!
                let viewModel = self.viewModel.items[index]
                let cell = EventsListDataSource.cell(
                    table: table,
                    forIndex: indexPath,
                    viewModel: viewModel
                )

                if let cell = cell as? EventCell { cell.cellAnimator = cellAnimator }

                return cell
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
        dataSource.register(table)
    }

    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.viewModel = self.factory.makeEventsListViewModel(self)
        }
    }

    @objc private func handleAdd() {
        guard !viewRoot.input.value.isEmpty else { return }

        if let renamedEventItem = viewModel.renamedItem {
            renamedEventItem.rename(to: viewRoot.input.value)
        } else {
            viewModel.add(name: viewRoot.input.value)
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
