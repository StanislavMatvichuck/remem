//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListViewController:
    UIViewController,
    UITableViewDataSource,
    UITableViewDelegate
{
    let viewRoot: EventsListView
    var viewModel: EventsListViewModel {
        didSet {
            guard isViewLoaded else { return }
            update()
            /// does not trigger didSet
            viewModel = connectToViewModelHandlers(viewModel: viewModel)
        }
    }

    let providers: [EventsListItemProviding]

    // MARK: - Init
    init(viewModel: EventsListViewModel, providers: [EventsListItemProviding]) {
        self.viewRoot = EventsListView()
        self.viewModel = viewModel
        self.providers = providers

        super.init(nibName: nil, bundle: nil)

        /// does not trigger didSet
        self.viewModel = connectToViewModelHandlers(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        update()
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { viewModel.numberOfSections }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { viewModel.rows(inSection: section) }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        providers[indexPath.section].dequeue(
            tableView,
            indexPath: indexPath,
            viewModel: viewModel.itemViewModel(
                row: indexPath.row,
                section: indexPath.section
            )
        )
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        (providers[indexPath.section].dequeue(
            tableView,
            indexPath: indexPath,
            viewModel: viewModel.itemViewModel(
                row: indexPath.row,
                section: indexPath.section
            )
        ) as? TrailingSwipeActionsConfigurationProviding)?.trailingActionsConfiguration()
    }

    private func setupTableView() {
        let table = viewRoot.table
        table.dataSource = self
        table.delegate = self

        for provider in providers {
            provider.register(table)
        }
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

    private func update() {
        title = viewModel.title

        viewRoot.table.reloadData()

        if let renamedItem = viewModel.renamedItem {
            viewRoot.input.rename(oldName: renamedItem.name)
        } else if viewModel.inputVisible {
            viewRoot.input.show(value: viewModel.inputContent)
        }
    }

    /// - Parameter viewModel: all handlers of this vm will be updated to
    /// - Parameter controller: self that plays multiple roles by extensions in viewModels files
    /// - Returns: new version of list view model with all handlers configured to call controller
    private func connectToViewModelHandlers(viewModel: EventsListViewModel) -> EventsListViewModel {
        var newViewModel = viewModel

        for (i, section) in newViewModel.sections.enumerated() {
            for (j, item) in section.enumerated() {
                newViewModel.sections[i][j] = item.add(self)
            }
        }

        return newViewModel
    }
}
