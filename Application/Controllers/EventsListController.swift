//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import Domain
import IosUseCases
import UIKit

class EventsListController: UIViewController {
    enum Section: Int, CaseIterable {
        case hint
        case events
        case footer
    }

    // MARK: - Properties
    var viewModel: EventsListViewModel
    let listUseCase: EventsListUseCasing
    let editUseCase: EventEditUseCasing
    weak var coordinator: Coordinating?
    let viewRoot: EventsListView

    // MARK: - Init
    init(viewRoot: EventsListView,
         listUseCase: EventsListUseCasing,
         editUseCase: EventEditUseCasing,
         coordinator: Coordinating)
    {
        self.viewRoot = viewRoot
        self.listUseCase = listUseCase
        self.editUseCase = editUseCase
        self.coordinator = coordinator

        self.viewModel = EventsListViewModel(events: listUseCase.makeAllEvents())

        super.init(nibName: nil, bundle: nil)

        listUseCase.add(delegate: self)
        editUseCase.add(delegate: self)
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
                self.viewModel.renamedEvent = event
                self.viewRoot.input.rename(oldName: event.name)
                completion(true)
        }

        let deleteAction = UIContextualAction(style: .destructive,
                                              title: String(localizationId: "button.delete")) {
                _, _, completion in
                self.listUseCase.remove(event)
                completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
    }

    @objc private func handleAddButton(sender: UIButton) {
        UIDevice.vibrate(.medium)
        sender.animate()
        viewRoot.input.show(value: "")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            indexPath.section == Section.events.rawValue,
            let event = viewModel.event(at: indexPath.row)
        else { return }

        coordinator?.showDetails(event: event)
    }
}

// MARK: - Events handling
extension EventsListController {
    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
        viewRoot.input.addTarget(self, action: #selector(handleCancel), for: .editingDidEndOnExit)
    }

    @objc private func handleAdd() {
        if let renaming = viewModel.renamedEvent {
            editUseCase.rename(renaming, to: viewRoot.input.value)
            viewModel.renamedEvent = nil
        } else {
            listUseCase.add(name: viewRoot.input.value)
        }
    }

    @objc private func handleCancel() {}
}

// MARK: - EventsListUseCasingDelegate, EventEditUseCasingDelegate
extension EventsListController:
    EventsListUseCasingDelegate,
    EventEditUseCasingDelegate
{
    func update(event: Domain.Event) {
        if let index = viewModel.events.firstIndex(of: event) {
            var newEvents = viewModel.events
            newEvents[index] = event
            viewModel = EventsListViewModel(events: newEvents)
            viewRoot.table.reloadRows(
                at: [IndexPath(
                    row: index,
                    section: Section.events.rawValue)],
                with: .none)
            hideSwipeHintIfNeeded()
        }
    }

    func update(events: [Event]) {
        viewModel = EventsListViewModel(events: events)
        hideSwipeHintIfNeeded()
        viewRoot.table.reloadData()
    }

    private func hideSwipeHintIfNeeded() {
        if viewModel.hint != .placeFirstMark {
            viewRoot.swipeHint.removeFromSuperview()
        }
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
            for: .touchUpInside)

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
            let viewModel = viewModel.eventViewModel(at: index.row)
        else { return UITableViewCell() }

        eventCell.viewModel = viewModel
        eventCell.useCase = editUseCase

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
