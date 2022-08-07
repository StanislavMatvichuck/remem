//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListController: UIViewController {
    // MARK: I18n
    static let delete = NSLocalizedString("button.contextual.delete", comment: "EventsList swipe gesture actions")

    // MARK: - Properties
    weak var coordinator: Coordinator?

    private let viewRoot = EventsListView()
    private var viewModel: EventsListViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    private let eventsListUseCase: EventsListUseCaseInput
    private let eventEditUseCase: EventEditUseCaseInput

    private var renamedEvent: Event?

    // MARK: - Init
    init(
        eventsListUseCase: EventsListUseCaseInput,
        eventEditUseCase: EventEditUseCaseInput)
    {
        self.eventsListUseCase = eventsListUseCase
        self.eventEditUseCase = eventEditUseCase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = "Events list"
        viewModel = EventsListViewModel(model: eventsListUseCase.allEvents())
        setupTableView()
        setupEventHandlers()
    }

    private func setupTableView() {
        viewRoot.viewTable.delegate = self
    }
}

// MARK: - Events handling
extension EventsListController:
    EventCellDelegate,
    EventsListFooterCellDelegate
{
    private func setupEventHandlers() {
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
        viewRoot.input.addTarget(self, action: #selector(handleCancel), for: .editingDidEndOnExit)
    }

    @objc private func handleAdd() {
        if let event = renamedEvent {
            eventEditUseCase.rename(event, to: viewRoot.input.value)
        } else {
            eventsListUseCase.add(name: viewRoot.input.value)
        }
    }

    @objc private func handleCancel() {
        renamedEvent = nil
    }

    // EventCellDelegate actions
    func didPressAction(_ cell: EventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let event = viewModel.event(at: index)
        else { return }
        coordinator?.showDetails(for: event)
    }

    func didSwipeAction(_ cell: EventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let event = viewModel.event(at: index)
        else { return }
        eventEditUseCase.addHappening(to: event, date: .now)
    }

    // EventsListFooterCellDelegate
    func add() { viewRoot.input.show(value: "") }

    // Swipe to left actions
    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        guard let event = viewModel.event(at: forIndexPath) else { return }
        eventsListUseCase.remove(event)
    }

    private func handleRenameContextualAction(_ forIndexPath: IndexPath) {
        guard let event = viewModel.event(at: forIndexPath) else { return }

        renamedEvent = event
        viewRoot.input.rename(oldName: event.name)
    }
}

// MARK: - UITableViewDelegate
extension EventsListController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        makeSwipeActionsConfiguration(for: indexPath)
    }

    func tableView(
        _ tableView: UITableView,
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

extension EventsListController: EventsListUseCaseOutput {
    func eventsListUpdated(_ list: [Event]) {
        viewModel = EventsListViewModel(model: list)
    }
}

extension EventsListController: EventEditUseCaseOutput {
    func updated(_: Event) {
        viewModel = EventsListViewModel(model: eventsListUseCase.allEvents())
    }
}

// MARK: - Private
extension EventsListController {
    private func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration {
        let renameAction = UIContextualAction(
            style: .normal,
            title: "Rename") { _, _, completion in
                self.handleRenameContextualAction(index)
                completion(true)
        }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: Self.delete) { _, _, completion in
                self.handleDeleteContextualAction(index)
                completion(true)
        }

        let config = UISwipeActionsConfiguration(actions: [deleteAction, renameAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
