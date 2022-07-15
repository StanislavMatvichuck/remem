//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class CountableEventsListController: UIViewController {
    // MARK: I18n
    static let delete = NSLocalizedString("button.contextual.delete", comment: "CountableEventsList swipe gesture actions")

    // MARK: - Properties
    private let viewRoot = CountableEventsListView()
    private var viewModel: CountableEventsListViewModel! {
        didSet { viewModel.configure(viewRoot) }
    }

    private let service = CountableEventsListService(CountableEventsRepository())

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        update()
        setupTableView()
        setupEventHandlers()
    }

    private func setupTableView() {
        viewRoot.viewTable.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewRoot.cellGestureView.start()
    }
}

// MARK: - Events handling
extension CountableEventsListController: CountableEventCellDelegate {
    private func setupEventHandlers() {
        viewRoot.buttonAdd.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleAddButton)))

        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    @objc private func handleAdd() {
        service.add(name: viewRoot.input.value)
        update()
    }

    @objc private func handleAddButton() { viewRoot.input.show() }

    // CountableEventCellDelegate actions
    func didPressAction(_ cell: CountableEventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let countableEvent = service.get(at: index.row)
        else { return }

        let detailsController = makeDetailsController(for: countableEvent)
        let navigationController = makeNavigationController(for: detailsController)

        present(navigationController, animated: true) {
            self.update()
        }
    }

    func didSwipeAction(_ cell: CountableEventCell) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        service.makeHappening(at: index.row)
        update()
    }

    // Swipe to left actions
    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        service.delete(at: forIndexPath.row)
        update()
    }
}

// MARK: - UITableViewDelegate
extension CountableEventsListController: UITableViewDelegate {
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
        guard let cell = cell as? CountableEventCell else { return }
        cell.delegate = self
    }
}

// MARK: - Private
extension CountableEventsListController {
    private func update() {
        let newList = service.getList()
        viewModel = CountableEventsListViewModel(model: newList)
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

    private func makeDetailsController(for countableEvent: CountableEvent) -> CountableEventDetailsController {
        let weekService = WeekService(countableEvent)

        let clockController = ClockController()
        let beltController = BeltController()
        let happeningsListController = CountableEventHappeningDescriptionsListController()
        let weekController = WeekController()

        clockController.countableEvent = countableEvent
        happeningsListController.countableEvent = countableEvent
        weekController.weekDistributionService = weekService

        return CountableEventDetailsController(countableEvent: countableEvent,
                                               clockController: clockController,
                                               happeningsListController: happeningsListController,
                                               weekController: weekController,
                                               beltController: beltController)
    }

    private func makeNavigationController(for controller: CountableEventDetailsController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: controller)

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = .clear

        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.compactAppearance = appearance

        return navigation
    }

    private func makeSwipeActionsConfiguration(for index: IndexPath) -> UISwipeActionsConfiguration {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            self.handleDeleteContextualAction(index)
            completion(true)
        }

        let deleteView: UILabel = {
            let label = UILabel()
            label.text = Self.delete
            label.textColor = .white
            label.font = .systemFont(ofSize: .font1, weight: .regular)
            label.sizeToFit()
            return label
        }()

        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(view: deleteView)

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
