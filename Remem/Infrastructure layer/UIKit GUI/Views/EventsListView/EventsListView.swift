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
    let input: UIMovableTextViewInterface
    let table: UITableView
    let swipeHint: SwipeGestureView
    let viewModel: EventsListViewModelInputState & EventsListViewModelInputEvents
    let container: EventsListViewFactory

    // MARK: - Init
    init(viewModel: EventsListViewModelInputState & EventsListViewModelInputEvents,
         container: EventsListViewFactory,
         input: UIMovableTextViewInterface,
         table: UITableView,
         swipeHint: SwipeGestureView)
    {
        self.input = input
        self.viewModel = viewModel
        self.container = container
        self.table = table
        self.swipeHint = swipeHint
        super.init(frame: .zero)
        table.dataSource = self
        table.delegate = self
        backgroundColor = UIHelper.itemBackground
        addAndConstrain(table)
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
            let index = table.indexPath(for: cell),
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
            table.reloadRows(at: [hintIndex, footerIndex], with: .none)
        }

        func hideSwipeHintIfNeeded() {
            if viewModel.hint != .placeFirstMark { swipeHint.removeFromSuperview() }
        }
    }

    func addEvent(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        table.insertRows(at: [path], with: .automatic)
    }

    func remove(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        table.deleteRows(at: [path], with: .automatic)
    }

    func update(at: Int) {
        let path = IndexPath(row: at, section: Section.events.rawValue)
        table.reloadRows(at: [path], with: .none)
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
            return container.makeHintCell()
        } else if Section(rawValue: indexPath.section) == .events {
            let cell = container.makeEventCellFor(indexPath)
            if let eventCell = cell as? EventCell { eventCell.delegate = self }
            return cell
        } else if Section(rawValue: indexPath.section) == .footer {
            return container.makeFooterCell()
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        container.makeSwipeActionsConfiguration(for: indexPath)
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
