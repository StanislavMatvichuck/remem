//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListViewController:
    UIViewController,
    UsingEventDependantViewModel
{
    let viewRoot: EventsListView
    var viewModel: EventsListViewModel {
        didSet {
            guard isViewLoaded else { return }
            update()
        }
    }

    let providers: [EventsListItemProviding]

    // MARK: - Init
    init(viewModel: EventsListViewModel, providers: [EventsListItemProviding]) {
        self.viewRoot = EventsListView()
        self.viewModel = viewModel
        self.providers = providers

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        update()
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
}

// MARK: - UITableViewDataSource
extension EventsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { viewModel.numberOfSections }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rows(inSection: section)
    }

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
}

extension EventsListViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let cell = providers[indexPath.section].dequeue(
            tableView,
            indexPath: indexPath,
            viewModel: viewModel.itemViewModel(
                row: indexPath.row,
                section: indexPath.section
            )
        ) as? TrailingSwipeActionsConfigurationProviding
        else { return nil }
        return cell.trailingActionsConfiguration()
    }
}
