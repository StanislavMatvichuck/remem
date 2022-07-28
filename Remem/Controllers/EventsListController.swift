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

        let detailsController = makeDetailsController(for: event)

        navigationController?.pushViewController(detailsController, animated: true)
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
    private func update() {
        let newList = service.getList()
        viewModel = EventsListViewModel(model: newList)
    }

    private func presentSettings() {
        let controller = SettingsController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }

        present(nav, animated: true, completion: nil)
    }

    private func makeDetailsController(for event: Event) -> EventDetailsController {
        let clockController = ClockController()
        let weekController = WeekController()

        clockController.event = event

        let details = EventDetailsController(event: event,
                                             clockController: clockController,
                                             weekController: weekController)
        details.delegate = self

        return details
    }

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

// MARK: - EventDetailsControllerDelegate
extension EventsListController: EventDetailsControllerDelegate {
    func didUpdate(event: Event) {
        // update row at index
        update()
    }
}
