//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol EventsListFactoryInterface {
    func makeEventCellViewModel(event: Event) -> EventCellViewModel
}

class EventsListController: UIViewController {
    // MARK: - Properties
    private let viewModel: EventsListViewModelInput
    private let viewRoot: EventsListView
    private let factory: EventsListFactoryInterface

    // MARK: - Init
    init(view: EventsListView,
         viewModel: EventsListViewModelInput,
         factory: EventsListFactoryInterface)
    {
        self.viewRoot = view
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        viewRoot.table.dataSource = self
        viewRoot.table.delegate = self
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { title = "Events list" }
}

// MARK: - UITableViewDataSource
extension EventsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        EventsListView.Section(rawValue: indexPath.section) == .events
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EventsListView.Section(rawValue: section) == .events ? viewModel.eventsAmount : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if EventsListView.Section(rawValue: indexPath.section) == .hint {
            return makeHintCell()
        } else if EventsListView.Section(rawValue: indexPath.section) == .events {
            return makeEventCell(for: indexPath)
        } else if EventsListView.Section(rawValue: indexPath.section) == .footer {
            return makeFooterCell()
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let event = viewModel.event(at: indexPath) else { return nil }

        let renameAction = UIContextualAction(style: .normal, title: EventsListView.rename) { _, _, completion in
            self.viewModel.selectForRenaming(event: event)
            completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: EventsListView.delete) { _, _, completion in
            self.viewModel.selectForRemoving(event: event)
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            indexPath.section == EventsListView.Section.footer.rawValue,
            let footer = viewRoot.table.cellForRow(at: indexPath) as? EventsListFooterCell
        else { return }
        UIDevice.vibrate(.medium)
        footer.animate()
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

// MARK: - EventsListViewModelOutput
extension EventsListController: EventsListViewModelOutput {
    func update() {
        updateHintsAndFooter()
        hideSwipeHintIfNeeded()

        func updateHintsAndFooter() {
            let hintIndex = IndexPath(row: 0, section: EventsListView.Section.hint.rawValue)
            let footerIndex = IndexPath(row: 0, section: EventsListView.Section.footer.rawValue)
            viewRoot.table.reloadRows(at: [hintIndex, footerIndex], with: .none)
        }

        func hideSwipeHintIfNeeded() {
            if viewModel.hint != .placeFirstMark { viewRoot.swipeHint.removeFromSuperview() }
        }
    }

    func addEvent(at: Int) {
        let path = IndexPath(row: at, section: EventsListView.Section.events.rawValue)
        viewRoot.table.insertRows(at: [path], with: .automatic)
    }

    func remove(at: Int) {
        let path = IndexPath(row: at, section: EventsListView.Section.events.rawValue)
        viewRoot.table.deleteRows(at: [path], with: .automatic)
    }

    func update(at: Int) {
        let path = IndexPath(row: at, section: EventsListView.Section.events.rawValue)
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
        cell.buttonAdd.backgroundColor = viewModel.isAddButtonHighlighted ? .systemBlue : UIHelper.background
        cell.buttonAdd.layer.borderColor = viewModel.isAddButtonHighlighted ? UIHelper.background.cgColor : UIHelper.brand.cgColor
        if let label = cell.buttonAdd.subviews[0] as? UILabel {
            label.textColor = viewModel.isAddButtonHighlighted ? UIHelper.background : UIHelper.brand
        }

        return cell
    }

    private func makeEventCell(for index: IndexPath) -> UITableViewCell {
        guard
            let eventCell = viewRoot.table.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let event = viewModel.event(at: index)
        else { return UITableViewCell() }

        let viewModel = factory.makeEventCellViewModel(event: event)
        viewModel.delegate = eventCell
        eventCell.viewModel = viewModel

        configureSwipeHintIfNeeded(at: index, cell: eventCell)
        return eventCell
    }

    private func configureSwipeHintIfNeeded(at indexPath: IndexPath, cell: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == EventsListView.Section.events.rawValue,
            viewModel.hint == .placeFirstMark
        else { return }
        cell.contentView.addAndConstrain(viewRoot.swipeHint)
        viewRoot.swipeHint.start()
    }
}
