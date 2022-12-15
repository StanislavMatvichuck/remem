//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import Domain
import UIKit

class EventsListViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case hint
        case events
        case footer
    }

    let viewRoot: EventsListView
    var viewModel: EventsListViewModel

    // MARK: - Init
    init(viewModel: EventsListViewModel) {
        self.viewRoot = EventsListView()
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = String(localizationId: "eventsList.title")
        setupTableView()
        setupEventHandlers()
    }

    private func setupTableView() {
        viewRoot.table.dataSource = self
        viewRoot.table.delegate = self
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
}

extension EventsListViewController: EventsListViewModelUpdating {
    func update(viewModel: EventsListViewModel) {
        self.viewModel = viewModel
        viewRoot.table.reloadData()

        if viewModel.hint != HintState.placeFirstMark.text {
            viewRoot.swipeHint.removeFromSuperview()
        }
    }
}

// MARK: - UITableViewDataSource
extension EventsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        Section(rawValue: indexPath.section) == .events
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section(rawValue: section) == .events ? viewModel.items.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Section(rawValue: indexPath.section) == .hint {
            return makeHintCell()
        } else if Section(rawValue: indexPath.section) == .events {
            return makeEventCell(for: indexPath)
        } else if Section(rawValue: indexPath.section) == .footer {
            return makeFooterCell()
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameAction = UIContextualAction(
            style: .normal,
            title: String(localizationId: "button.rename")
        ) { _, _, completion in
            self.viewModel.renamedItem = self.viewModel.items[indexPath.row]
            self.viewRoot.input.rename(oldName: self.viewModel.items[indexPath.row].event.name)
            completion(true)
        }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: String(localizationId: "button.delete")
        ) { _, _, completion in
            self.viewModel.items[indexPath.row].remove()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
    }

    @objc private func handleAddButton(sender: UIButton) {
        UIDevice.vibrate(.medium)
        sender.animate()
        viewRoot.input.show(value: "")
    }
}

// MARK: - Private
extension EventsListViewController {
    private func makeHintCell() -> UITableViewCell {
        let cell = viewRoot.table.dequeueReusableCell(withIdentifier: EventsListHintItem.reuseIdentifier) as! EventsListHintItem
        cell.label.text = viewModel.hint

        if viewModel.hint == HintState.swipeLeft.text {
            cell.label.font = UIHelper.fontSmall
            cell.label.textColor = UIHelper.hint
        } else {
            cell.label.font = UIHelper.fontBold
            cell.label.textColor = UIHelper.itemFont
        }

        return cell
    }

    private func makeFooterCell() -> UITableViewCell {
        let cell = viewRoot.table.dequeueReusableCell(withIdentifier: EventsListFooterItem.reuseIdentifier) as! EventsListFooterItem

        cell.button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)

        viewModel.items.isEmpty ? cell.highlight() : cell.resignHighlight()

        return cell
    }

    private func makeEventCell(for index: IndexPath) -> UITableViewCell {
        guard let eventCell = viewRoot.table.dequeueReusableCell(
            withIdentifier: EventsListItem.reuseIdentifier
        ) as? EventsListItem else { fatalError("unable to get EventCell") }

        eventCell.viewModel = viewModel.items[index.row]
        configureSwipeHintIfNeeded(at: index, cell: eventCell)
        return eventCell
    }

    private func configureSwipeHintIfNeeded(at indexPath: IndexPath, cell: EventsListItem) {
        guard
            indexPath.row == 0,
            indexPath.section == Section.events.rawValue,
            viewModel.hint == HintState.placeFirstMark.text
        else { return }
        cell.contentView.addAndConstrain(viewRoot.swipeHint)
        viewRoot.swipeHint.start()
    }
}
