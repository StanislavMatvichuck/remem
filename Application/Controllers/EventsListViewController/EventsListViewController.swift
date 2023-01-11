//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import Domain
import UIKit

// TODO: make viewModel property + didSet configuration be same everywhere
// TODO: procedural if's to polymorphism?
/// common cell interface?
/// func configure(some)?
/// where cell type must live?
/// what handles events? (itemViewModel + this controller currently)
/// make cell based on `type` of view model?
/// direct mapping of `vm type (props + methods)` with `cell type (view, vm)`
/// who is responsible for that mapping? controller
/// THIS STUFF IMPROVES EXTENSIBILITY BY ENABLING ARBITRARY AMOUNT OF CELL TYPES
/// ALSO A PLUS that separate functionality like hints and add button obtain their clear view models. From that perspective hint = event = footer. Also = week = day = clock.
///   ALL ITEMS ARE SOMEHOW EQUAL IN VM. But different in table/collection/clock usage
// TODO: is it possible to describe items with capability protocols? what are consequences?
// for example: swipeable, selectable, swipeActionsContaining, update receiving
// TODO: how will it exchange with existing tests? is it a refactoring? no code should be broken during codebase update

class EventsListViewController:
    UIViewController,
    UsingEventDependantViewModel
{
    let viewRoot: EventsListView
    var viewModel: EventsListViewModel {
        didSet {
            if isViewLoaded { update() }
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

        if !viewModel.gestureHintEnabled {
            viewRoot.swipeHint.removeFromSuperview()
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
        let cell = providers[indexPath.section].dequeue(
            tableView,
            indexPath: indexPath,
            viewModel: viewModel.itemViewModel(
                row: indexPath.row,
                section: indexPath.section
            )
        )

        if
            viewModel.gestureHintEnabled,
            indexPath == IndexPath(row: 0, section: 1)
        {
            let hint = viewRoot.swipeHint
            cell.contentView.addAndConstrain(hint)
            hint.start()
        }

        return cell
    }
}

extension EventsListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let renameAction = UIContextualAction(
//            style: .normal,
//            title: viewModel.rename
//        ) { _, _, completion in
//            self.viewModel.renamedItem = self.viewModel.itemViewModel(
//                row: indexPath.row,
//                section: indexPath.section
//            )
//            completion(true)
//        }
//
//        let deleteAction = UIContextualAction(
//            style: .destructive,
//            title: viewModel.delete
//        ) { _, _, completion in
//            self.viewModel.items[indexPath.row].remove()
//            completion(true)
//        }
//
//        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
//    }
}
