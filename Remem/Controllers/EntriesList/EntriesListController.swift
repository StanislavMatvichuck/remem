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
    private var cellIndexToBeAnimated: IndexPath?
    private var newCellIndex: IndexPath?
    private let cellsAnimator = EntryCellAnimator()

    // MARK: - Init
    deinit { NotificationCenter.default.removeObserver(self) }

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

// MARK: - Private
extension EntriesListController {
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
            addPressMeAnimationsForCells()
        case .noHints:
            removePressMeAnimationsFromCells()
        }
    }

    private func addPressMeAnimationsForCells() {
        for cell in viewRoot.viewTable.visibleCells {
            guard let cell = cell as? EntryCell else { continue }
            cellsAnimator.pressMe(cell: cell)
        }
    }

    private func removePressMeAnimationsFromCells() {
        for cell in viewRoot.viewTable.visibleCells {
            guard let cell = cell as? EntryCell else { continue }
            cellsAnimator.removeAnimations(from: cell)
        }
    }
}

// MARK: - Events handling
extension EntriesListController {
    private func setupEventHandlers() {
        viewRoot.swiper.addTarget(self, action: #selector(handleSwiperSelection),
                                  for: .primaryActionTriggered)
        viewRoot.input.addTarget(self, action: #selector(handleAdd),
                                 for: .editingDidEnd)
    }

    @objc private func handleAdd() {
        domain.makeEntry(name: viewRoot.input.value)
        updateUI()
    }

    @objc private func handleSwiperSelection(_ sender: UISwipingSelector) {
        guard let selectedOption = sender.value else { return }
        switch selectedOption {
        case .addEntry:
            viewRoot.input.show()
        case .settings:
            presentSettings()
        }
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
        row.animator = cellsAnimator
        row.update(name: dataRow.name!)
        row.update(value: dataRow.totalAmount)

        return row
    }
}

// MARK: - UITableViewDelegate
extension EntriesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellIndexToBeAnimated == indexPath, let cell = cell as? EntryCell {
            cellsAnimator.pointAdded(cell: cell)
        }
    }

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

// MARK: - UIScrollViewDelegate
extension EntriesListController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewRoot.swiper.handleScrollView(contentOffset: scrollView.contentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewRoot.swiper.handleScrollViewDraggingEnd()
    }
}

// MARK: - EntryCellDelegate
extension EntriesListController: EntryCellDelegate {
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

        cellIndexToBeAnimated = index
        domain.makePoint(for: entry, dateTime: .now)
        updateUI()
    }

    func didAnimation(_ cell: EntryCell) { cellIndexToBeAnimated = nil }
}

// MARK: - Private
extension EntriesListController {
    private func updateUI() {
        viewRoot.viewTable.reloadData()
        configureHintsVisibility()
    }

    private func makeDetailsController(for entry: Entry) -> EntryDetailsController {
        let stack = CoreDataStack()

        let entryDetailsService = EntryDetailsService(entry, stack: stack)
        let clockService = ClockService(entry, stack: stack)
        let pointsListService = PointsListService(entry)
        let weekService = WeekService(entry)

        let beltController = BeltController()
        let clockController = ClockController(service: clockService, freshPoint: entry.freshPoint)
        let pointsListController = PointsListController()
        let weekController = WeekController()

        pointsListController.pointsListService = pointsListService
        weekController.weekDistributionService = weekService

        return EntryDetailsController(entry: entry,
                                      service: entryDetailsService,
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
