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
    private let domain = DomainFacade()
    private let viewRoot = CountableEventsListView()

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        configureHintsVisibility()
    }

    private func setupTableView() {
        viewRoot.viewTable.dataSource = self
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
        viewRoot.buttonAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddButton)))
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    @objc private func handleAdd() {
        domain.makeCountableEvent(name: viewRoot.input.value)
        updateUI()
    }

    @objc private func handleAddButton() { viewRoot.input.show() }

    //
    // CountableEventCellDelegate actions
    //
    func didPressAction(_ cell: CountableEventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let countableEvent = domain.countableEvent(at: index.row)
        else { return }

        let detailsController = makeDetailsController(for: countableEvent)
        let navigationController = makeNavigationController(for: detailsController)

        present(navigationController, animated: true) {
            self.updateUI()
        }
    }

    func didSwipeAction(_ cell: CountableEventCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let countableEvent = domain.countableEvent(at: index.row)
        else { return }

        domain.makeCountableEventHappeningDescription(for: countableEvent, dateTime: .now)
        updateUI()
    }
}

// MARK: - UITableViewDataSource
extension CountableEventsListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { domain.getCountableEventsAmount() }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: CountableEventCell.reuseIdentifier) as? CountableEventCell,
            let dataRow = domain.countableEvent(at: indexPath.row)
        else { return UITableViewCell() }

        row.delegate = self
        row.configure(name: dataRow.name!, value: dataRow.totalAmount)

        return row
    }
}

// MARK: - UITableViewDelegate
extension CountableEventsListController: UITableViewDelegate {
    // MARK: Right to left row swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            self.handleDeleteContextualAction(indexPath)
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

    private func handleDeleteContextualAction(_ forIndexPath: IndexPath) {
        guard let countableEvent = domain.countableEvent(at: forIndexPath.row) else { return }
        domain.delete(countableEvent: countableEvent)
        updateUI()
    }
}

// MARK: - Private
extension CountableEventsListController {
    private func updateUI() {
        viewRoot.viewTable.reloadData()
        configureHintsVisibility()
    }

    private func createManipulationAlert(for countableEvent: CountableEvent) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.domain.delete(countableEvent: countableEvent)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
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

    private func configureHintsVisibility() {
        viewRoot.hideAllHints()
        switch domain.getHintState() {
        case .empty:
            viewRoot.showEmptyState()
        case .placeFirstMark:
            viewRoot.showFirstCountableEventHappeningDescriptionState()
        case .pressMe:
            viewRoot.showFirstDetails()
//            addPressMeAnimationsForCells()
        case .noHints:
            print(#function)
//            removePressMeAnimationsFromCells()
        }
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
}
