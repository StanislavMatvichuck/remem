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
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        return view
    }()

    lazy var hint: EventsListHintCell = {
        let cell = EventsListHintCell(
            style: .default,
            reuseIdentifier: EventsListHintCell.reuseIdentifier)
        return cell
    }()

    lazy var footer: EventsListFooterCell = {
        let cell = EventsListFooterCell(
            style: .default,
            reuseIdentifier: EventsListFooterCell.reuseIdentifier)
        return cell
    }()

    private let viewModel: EventsListViewModelState & EventsListViewModelEvents

    // MARK: - Init
    init(viewModel: EventsListViewModelState & EventsListViewModelEvents) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        backgroundColor = UIHelper.itemBackground
        setupLayout()
        addAndConstrain(input)
        setupEventHandlers()
        update()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Sending user actions to view model
extension EventsListView: EventCellDelegate, EventsListFooterCellDelegate {
    private func setupEventHandlers() {
        input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
        input.addTarget(self, action: #selector(handleCancel), for: .editingDidEndOnExit)
    }

    @objc private func handleAdd() { viewModel.submitNameEditing(name: input.value) }
    @objc private func handleCancel() { viewModel.cancelNameEditing() }

    // EventCellDelegate actions
    func didPressAction(_ cell: EventCell) {
        guard
            let index = viewTable.indexPath(for: cell),
            let event = viewModel.event(at: index)
        else { return }
        viewModel.select(event: event)
    }

    func didSwipeAction(_ cell: EventCell) {
        guard
            let index = viewTable.indexPath(for: cell),
            let event = viewModel.event(at: index)
        else { return }
        viewModel.addHappening(to: event)
    }

    // EventsListFooterCellDelegate
    func add() { input.show(value: "") }

    // Swipe to left actions
    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        guard let event = viewModel.event(at: forIndexPath) else { return }
        viewModel.selectForRemoving(event: event)
    }

    private func handleRenameContextualAction(_ forIndexPath: IndexPath) {
        guard let event = viewModel.event(at: forIndexPath) else { return }
        viewModel.selectForRenaming(event: event)
    }
}

// MARK: - Private
extension EventsListView {
    private func setupLayout() {
        addSubview(viewTable)

        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewTable.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension EventsListView: EventsListViewModelOutput {
    func update() {
        configureAddButton()
        configureHintText()
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
        viewTable.reloadRows(at: [path], with: .automatic)
    }

    func askNewName(withOldName: String) {
        input.rename(oldName: withOldName)
    }

    private func configureAddButton() {
        footer.buttonAdd.backgroundColor = viewModel.isAddButtonHighlighted ? .systemBlue : .systemGray
    }

    private func configureHintText() {
        switch viewModel.hint {
        case .empty:
            hint.label.text = EventsListView.empty
        case .placeFirstMark:
            hint.label.text = EventsListView.firstHappening
        case .pressMe:
            hint.label.text = EventsListView.firstDetails
        case .noHints:
            hint.label.text = nil
        }
    }
}

// MARK: - DataSourcing
extension EventsListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        Section(rawValue: indexPath.section) == .events
    }

    func numberOfSections(in tableView: UITableView) -> Int { 3 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Section(rawValue: section) == .hint {
            return 1
        } else if Section(rawValue: section) == .events {
            return viewModel.eventsAmount
        } else if Section(rawValue: section) == .footer {
            return 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Section(rawValue: indexPath.section) == .hint {
            return hint
        } else if Section(rawValue: indexPath.section) == .events {
            return makeEventCellFor(indexPath)
        } else if Section(rawValue: indexPath.section) == .footer {
            return footer
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    { makeSwipeActionsConfiguration(for: indexPath) }

    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath)
    {
        if let cell = cell as? EventCell {
            cell.delegate = self
        } else if let cell = cell as? EventsListFooterCell {
            cell.delegate = self
        }
    }
}

// MARK: - Private
extension EventsListView {
    private func makeEventCellFor(_ index: IndexPath) -> UITableViewCell {
        guard
            let row = viewTable.dequeueReusableCell(withIdentifier: EventCell.reuseIdentifier) as? EventCell,
            let dataRow = viewModel.event(at: index)
        else { return UITableViewCell() }

        row.configure(name: dataRow.name, value: dataRow.happenings.count)
        setupSwipeHint(index, row)
        return row
    }

    private func setupSwipeHint(_ indexPath: IndexPath, _ row: EventCell) {
        guard
            indexPath.row == 0,
            indexPath.section == 1,
            viewModel.hint == .placeFirstMark
        else {
            removeSwipeHint(from: row)
            return
        }

        let swipeView = SwipeGestureView(mode: .horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)
        row.contentView.addAndConstrain(swipeView)
        swipeView.start()
    }

    private func removeSwipeHint(from row: EventCell) {
        for view in row.contentView.subviews where view is SwipeGestureView {
            view.removeFromSuperview()
        }
    }

    private func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration {
        let renameAction = UIContextualAction(style: .normal,
                                              title: "Rename") { _, _, completion in
                self.handleRenameContextualAction(index)
                completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: Self.delete) { _, _, completion in
                self.handleDeleteContextualAction(index)
                completion(true)
        }

        let config = UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
