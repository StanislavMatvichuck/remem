//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListController: UIViewController {
    enum Section: Int, CaseIterable {
        case hint
        case events
        case footer
    }

    // MARK: - Properties
    private let viewModel: EventsListViewModeling
    let viewRoot: EventsListView

    // MARK: - Init
    init(viewRoot: EventsListView,
         viewModel: EventsListViewModeling)
    {
        self.viewRoot = viewRoot
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
}

// MARK: - UITableViewDataSource
extension EventsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        Section(rawValue: indexPath.section) == .events
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section(rawValue: section) == .events ? viewModel.count : 1
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
extension EventsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let event = viewModel.event(at: indexPath.row) else { return nil }

        let renameAction = UIContextualAction(style: .normal,
                                              title: String(localizationId: "button.rename")) {
            _, _, completion in
            self.viewModel.selectForRenaming(event: event)
            completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: String(localizationId: "button.delete")) {
            _, _, completion in
            self.viewModel.selectForRemoving(event: event)
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

// MARK: - Events handling
extension EventsListController {
    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
        viewRoot.input.addTarget(self, action: #selector(handleCancel), for: .editingDidEndOnExit)
    }

    @objc private func handleAdd() { viewModel.submitNameEditing(name: viewRoot.input.value) }
    @objc private func handleCancel() { viewModel.cancelNameEditing() }
}

// MARK: - EventsListViewModelDelegate
extension EventsListController: EventsListViewModelDelegate {
    func update() {
        updateHints()
        hideSwipeHintIfNeeded()

        func updateHints() {
            let hintIndex = IndexPath(row: 0, section: Section.hint.rawValue)
            viewRoot.table.reloadRows(at: [hintIndex], with: .right)
        }

        func hideSwipeHintIfNeeded() {
            if viewModel.hint != .placeFirstMark { viewRoot.swipeHint.removeFromSuperview() }
        }
    }

    func addEvent(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewRoot.table.insertRows(at: [path], with: .top)

        if viewModel.count <= 1 {
            let footerIndex = IndexPath(row: 0, section: Section.footer.rawValue)
            viewRoot.table.reloadRows(at: [footerIndex], with: .none)
        }
    }

    func remove(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewRoot.table.deleteRows(at: [path], with: .none)

        if viewModel.count == 0 {
            let footerIndex = IndexPath(row: 0, section: Section.footer.rawValue)
            viewRoot.table.reloadRows(at: [footerIndex], with: .none)
        }
    }

    func update(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewRoot.table.reloadRows(at: [path], with: .none)
    }

    func askNewName(withOldName: String) {
        viewRoot.input.rename(oldName: withOldName)
    }
}

// MARK: - Private
extension EventsListController {
    private func makeHintCell() -> UITableViewCell {
        let cell = viewRoot.table.dequeueReusableCell(withIdentifier: EventsListHintCell.reuseIdentifier) as! EventsListHintCell
        cell.label.text = viewModel.hint.text

        if viewModel.hint == .swipeLeft {
            cell.label.font = UIHelper.fontSmall
            cell.label.textColor = UIHelper.hint
        } else {
            cell.label.font = UIHelper.fontBold
            cell.label.textColor = UIHelper.itemFont
        }

        return cell
    }

    private func makeFooterCell() -> UITableViewCell {
        let cell = viewRoot.table.dequeueReusableCell(withIdentifier: EventsListFooterCell.reuseIdentifier) as! EventsListFooterCell

        cell.createEvent.addTarget(
            self,
            action: #selector(handleAddButton),
            for: .touchUpInside
        )

        if viewModel.isAddButtonHighlighted {
            cell.highlight()
        } else {
            cell.resignHighlight()
        }

        return cell
    }

    private func makeEventCell(for index: IndexPath) -> UITableViewCell {
        guard
            let eventCell = viewRoot.table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let viewModel = viewModel.cellVM(at: index.row)
        else { return UITableViewCell() }

        viewModel.delegate = eventCell
        eventCell.viewModel = viewModel

        configureSwipeHintIfNeeded(at: index, cell: eventCell)
        return eventCell
    }

    private func configureSwipeHintIfNeeded(at indexPath: IndexPath, cell: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == Section.events.rawValue,
            viewModel.hint == .placeFirstMark
        else { return }
        cell.contentView.addAndConstrain(viewRoot.swipeHint)
        viewRoot.swipeHint.start()
    }
}
