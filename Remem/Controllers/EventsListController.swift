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
        viewModel = EventsListViewModel(model: eventsListUseCase.list())
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
    }

    @objc private func handleAdd() { eventsListUseCase.add(name: viewRoot.input.value) }

    // EventCellDelegate actions
    func didPressAction(_ cell: EventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let event = eventsListUseCase.event(at: index.row)
        else { return }
        coordinator?.showDetails(for: event)
    }

    func didSwipeAction(_ cell: EventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let event = eventsListUseCase.event(at: index.row)
        else { return }
        eventEditUseCase.addHappening(to: event, date: .now)
    }

    // EventsListFooterCellDelegate
    func add() { viewRoot.input.show() }

    // Swipe to left actions
    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        guard let event = eventsListUseCase.event(at: forIndexPath.row) else { return }
        eventsListUseCase.remove(event)
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
    func eventsListUpdated(_ list: [DomainEvent]) {
        viewModel = EventsListViewModel(model: list)
    }
}

extension EventsListController: EventEditUseCaseOutput {
    func updated(_: DomainEvent) {
        viewModel = EventsListViewModel(model: eventsListUseCase.list())
    }
}

// MARK: - Private
extension EventsListController {
    private func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction =
            UIContextualAction(
                style: .destructive,
                title: Self.delete) { _, _, completion in
                    self.handleDeleteContextualAction(index)
                    completion(true)
            }

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
