//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EntriesListController: UIViewController {
    // MARK: I18n
    static let delete = NSLocalizedString("button.contextual.delete", comment: "EntriesList swipe gesture actions")

    // MARK: - Properties
    private let domain = DomainFacade()
    private let viewRoot = EntriesListView()

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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: maybe move this to didAppear?
        viewRoot.gestureView.start()
        viewRoot.cellGestureView.start()
    }
}

// MARK: - Events handling
extension EntriesListController: EntryCellDelegate {
    private func setupEventHandlers() {
        viewRoot.buttonAdd.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddButton)))
        viewRoot.input.addTarget(self, action: #selector(handleAdd), for: .editingDidEnd)
    }

    @objc private func handleAdd() {
        domain.makeEntry(name: viewRoot.input.value)
        updateUI()
    }

    @objc private func handleAddButton() { viewRoot.input.show() }

    //
    // EntryCellDelegate actions
    //
    func didPressAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = domain.entry(at: index.row)
        else { return }

        let detailsController = makeDetailsController(for: entry)
        let navigationController = makeNavigationController(for: detailsController)

        present(navigationController, animated: true)
    }

    func didSwipeAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = domain.entry(at: index.row)
        else { return }

        domain.makePoint(for: entry, dateTime: .now)
        updateUI()
    }
}

// MARK: - UITableViewDataSource
extension EntriesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { domain.getEntriesAmount() }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier) as? EntryCell,
            let dataRow = domain.entry(at: indexPath.row)
        else { return UITableViewCell() }

        row.delegate = self
        row.configure(name: dataRow.name!, value: dataRow.totalAmount)

        return row
    }
}

// MARK: - UITableViewDelegate
extension EntriesListController: UITableViewDelegate {
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
        guard let entry = domain.entry(at: forIndexPath.row) else { return }
        domain.delete(entry: entry)
        updateUI()
    }
}

// MARK: - Private
extension EntriesListController {
    private func updateUI() {
        viewRoot.viewTable.reloadData()
        configureHintsVisibility()
    }

    private func createManipulationAlert(for entry: Entry) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.domain.delete(entry: entry)
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
            viewRoot.showFirstPointState()
        case .pressMe:
            viewRoot.showFirstDetails()
//            addPressMeAnimationsForCells()
        case .noHints:
            print(#function)
//            removePressMeAnimationsFromCells()
        }
    }

    private func makeDetailsController(for entry: Entry) -> EntryDetailsController {
        let pointsListService = PointsListService(entry)
        let weekService = WeekService(entry)

        let clockController = ClockController()
        clockController.entry = entry
        let beltController = BeltController()
        let pointsListController = PointsListController()
        let weekController = WeekController()

        pointsListController.pointsListService = pointsListService
        weekController.weekDistributionService = weekService

        return EntryDetailsController(entry: entry,
                                      clockController: clockController,
                                      pointsListController: pointsListController,
                                      weekController: weekController,
                                      beltController: beltController)
    }

    private func makeNavigationController(for controller: EntryDetailsController) -> UINavigationController {
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
