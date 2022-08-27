//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListView: UIView {
    // MARK: I18n
    static let empty = NSLocalizedString("empty.EventsList", comment: "entries list empty")
    static let firstHappening = NSLocalizedString("empty.EventsList.firstHappening", comment: "entries list first point")
    static let firstDetails = NSLocalizedString("empty.EventsList.firstDetailsInspection", comment: "entries list first details opening")
    static let delete = NSLocalizedString("button.contextual.delete", comment: "EventsList swipe gesture actions")
    static let rename = NSLocalizedString("button.contextual.rename", comment: "EventsList swipe gesture actions")

    // MARK: - Related types
    enum Section: Int {
        case hint
        case events
        case footer
    }

    // MARK: - Properties
    let input: UIMovableTextViewInterface = UIMovableTextView()

    lazy var viewTable: UITableView = {
        let view = UITableView(al: true)
        view.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseIdentifier)
        view.register(EventsListHintCell.self, forCellReuseIdentifier: EventsListHintCell.reuseIdentifier)
        view.register(EventsListFooterCell.self, forCellReuseIdentifier: EventsListFooterCell.reuseIdentifier)
        view.backgroundColor = .clear
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        return view
    }()

    lazy var swipeHint = SwipeGestureView(mode: .horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)

    private let viewModel: EventsListViewModelInputState & EventsListViewModelInputEvents

    // MARK: - Init
    init(viewModel: EventsListViewModelInputState & EventsListViewModelInputEvents) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        backgroundColor = UIHelper.itemBackground
        addAndConstrain(viewTable)
        addAndConstrain(input)
        setupEventHandlers()
        update()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Sending user actions to view model
extension EventsListView: EventCellDelegate {
    private func setupEventHandlers() {
        input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
        input.addTarget(self, action: #selector(handleCancel), for: .editingDidEndOnExit)
    }

    @objc private func handleAdd() { viewModel.submitNameEditing(name: input.value) }
    @objc private func handleCancel() { viewModel.cancelNameEditing() }

    // EventCellDelegate actions
    func didPressAction(_ cell: EventCell) {
        if let event = event(for: cell) { viewModel.select(event: event) }
    }

    func didSwipeAction(_ cell: EventCell) {
        if let event = event(for: cell) { viewModel.addHappening(to: event) }
    }

    private func event(for cell: UITableViewCell) -> Event? {
        guard
            let index = viewTable.indexPath(for: cell),
            let event = viewModel.event(at: index)
        else { return nil }
        return event
    }
}

// MARK: - EventsListViewModelOutput
extension EventsListView: EventsListViewModelOutput {
    func update() {
        updateHintsAndFooter()
        hideSwipeHintIfNeeded()

        func updateHintsAndFooter() {
            let hintIndex = IndexPath(row: 0, section: Section.hint.rawValue)
            let footerIndex = IndexPath(row: 0, section: Section.footer.rawValue)
            viewTable.reloadRows(at: [hintIndex, footerIndex], with: .none)
        }

        func hideSwipeHintIfNeeded() {
            if viewModel.hint != .placeFirstMark { swipeHint.removeFromSuperview() }
        }
    }

    func addEvent(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewTable.insertRows(at: [path], with: .automatic)
    }

    func remove(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewTable.deleteRows(at: [path], with: .automatic)
    }

    func update(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        viewTable.reloadRows(at: [path], with: .none)
    }

    func askNewName(withOldName: String) {
        input.rename(oldName: withOldName)
    }
}

// MARK: - DataSourcing
extension EventsListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        Section(rawValue: indexPath.section) == .events
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Section(rawValue: section) == .events ? viewModel.eventsAmount : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Section(rawValue: indexPath.section) == .hint {
            return makeHintCell()
        } else if Section(rawValue: indexPath.section) == .events {
            return makeEventCellFor(indexPath)
        } else if Section(rawValue: indexPath.section) == .footer {
            return makeFooterCell()
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        makeSwipeActionsConfiguration(for: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            indexPath.section == Section.footer.rawValue,
            let footer = tableView.cellForRow(at: indexPath) as? EventsListFooterCell
        else { return }
        UIDevice.vibrate(.medium)
        footer.animate()
        input.show(value: "")
    }
}

// MARK: - Private
extension EventsListView {
    private func makeFooterCell() -> EventsListFooterCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: EventsListFooterCell.reuseIdentifier) as! EventsListFooterCell
        cell.buttonAdd.backgroundColor = viewModel.isAddButtonHighlighted ? .systemBlue : .systemGray
        return cell
    }

    private func makeHintCell() -> EventsListHintCell {
        let cell = viewTable.dequeueReusableCell(withIdentifier: EventsListHintCell.reuseIdentifier) as! EventsListHintCell
        switch viewModel.hint {
        case .empty:
            cell.label.text = EventsListView.empty
        case .placeFirstMark:
            cell.label.text = EventsListView.firstHappening
        case .pressMe:
            cell.label.text = EventsListView.firstDetails
        case .noHints:
            cell.label.text = "-"
        }
        return cell
    }

    private func makeEventCellFor(_ index: IndexPath) -> UITableViewCell {
        guard
            let row = viewTable.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let dataRow = viewModel.event(at: index)
        else { return UITableViewCell() }
        row.configure(name: dataRow.name, value: dataRow.happenings.count)
        configureSwipeHintIfNeeded(index, row)
        row.delegate = self
        return row
    }

    private func configureSwipeHintIfNeeded(_ indexPath: IndexPath, _ row: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == Section.events.rawValue,
            viewModel.hint == .placeFirstMark
        else { return }
        row.contentView.addAndConstrain(swipeHint)
        swipeHint.start()
    }

    private func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration {
        let renameAction = UIContextualAction(style: .normal, title: Self.rename) { _, _, completion in
            guard let event = self.viewModel.event(at: index) else { return }
            self.viewModel.selectForRenaming(event: event)
            completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive, title: Self.delete) { _, _, completion in
            guard let event = self.viewModel.event(at: index) else { return }
            self.viewModel.selectForRemoving(event: event)
            completion(true)
        }

        let config = UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
