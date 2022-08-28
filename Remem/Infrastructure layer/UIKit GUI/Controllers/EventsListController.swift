//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol EventsListFactoryInterface {
    func makeHintCell() -> UITableViewCell
    func makeFooterCell() -> UITableViewCell
    func makeEventCell(for: IndexPath) -> UITableViewCell
    func makeSwipeActionsConfiguration(for: IndexPath) -> UISwipeActionsConfiguration?
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
            return factory.makeHintCell()
        } else if EventsListView.Section(rawValue: indexPath.section) == .events {
            return factory.makeEventCell(for: indexPath)
        } else if EventsListView.Section(rawValue: indexPath.section) == .footer {
            return factory.makeFooterCell()
        }

        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension EventsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        factory.makeSwipeActionsConfiguration(for: indexPath)
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
