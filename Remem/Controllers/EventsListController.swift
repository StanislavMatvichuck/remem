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

    private let service = EventsListService(EventsRepository())

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = "Events list"
        update()
        setupTableView()
        setupEventHandlers()
    }

    private func setupTableView() {
        viewRoot.viewTable.delegate = self
    }
}

// MARK: - Public
extension EventsListController {
    func update() {
        let newList = service.getList()
        viewModel = EventsListViewModel(model: newList)
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

    @objc private func handleAdd() {
        service.add(name: viewRoot.input.value)
        update()
    }

    // EventCellDelegate actions
    func didPressAction(_ cell: EventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let event = service.get(at: index.row)
        else { return }

        coordinator?.showDetails(for: event)
    }

    func didSwipeAction(_ cell: EventCell) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        service.makeHappening(at: index.row)
        update()
    }

    // EventsListFooterCellDelegate
    func add() { viewRoot.input.show() }

    // Swipe to left actions
    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        service.delete(at: forIndexPath.row)
        update()
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
