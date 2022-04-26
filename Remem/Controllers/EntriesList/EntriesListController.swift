//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import CoreData
import UIKit

class EntriesListController: UIViewController {
    // MARK: - Properties

    var service: EntriesListService!
    var coreDataStack: CoreDataStack!

    private let viewRoot = EntriesListView()
    private var cellIndexToBeAnimated: IndexPath?
    /// Used for posting `EntriesListNewEntry` notification
    private var newCellIndex: IndexPath?
    
    // MARK: - Init
    init() { super.init(nibName: nil, bundle: nil) }
    deinit { NotificationCenter.default.removeObserver(self) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupTableView()
        setupEventHandlers()
        service.fetch()
    }

    private func setupTableView() {
        viewRoot.viewTable.dataSource = self
        viewRoot.viewTable.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startOnboardingForNewUser()
    }
}

// MARK: - Internal
extension EntriesListController {
    private func createManipulationAlert(for entry: Entry) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.service.remove(entry: entry)
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
        service.create(entryName: viewRoot.input.value)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataAmount = service.dataAmount
        dataAmount == 0 ? viewRoot.showEmptyState() : viewRoot.hideEmptyState()
        return dataAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier) as? EntryCell,
            let dataRow = service.entry(at: indexPath)
        else { return UITableViewCell() }
        
        row.delegate = self
        row.update(name: dataRow.name!)
        row.update(value: dataRow.totalAmount)
        
        return row
    }
}

// MARK: - UITableViewDelegate
extension EntriesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cellIndexToBeAnimated == indexPath, let cell = cell as? EntryCell {
            cell.animateMovableViewBack()
        }
        
        if newCellIndex == indexPath {
            NotificationCenter.default.post(name: .EntriesListNewEntry, object: cell)
            newCellIndex = nil
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension EntriesListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewTable.beginUpdates()
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath else { return }
            newCellIndex = insertIndex
            viewRoot.viewTable.insertRows(at: [insertIndex], with: .automatic)
        case .delete:
            guard let deleteIndex = indexPath else { return }
            viewRoot.viewTable.deleteRows(at: [deleteIndex], with: .automatic)
        case .move:
            guard let fromIndex = indexPath, let toIndex = newIndexPath else { return }
            viewRoot.viewTable.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            viewRoot.viewTable.reloadRows(at: [updateIndex], with: .none)
        @unknown default:
            fatalError("Unhandled case")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewTable.endUpdates()
    }
}

// MARK: - EntriesListServiceDelegate
extension EntriesListController: EntriesListModelDelegate {
    func newPointAdded(at index: IndexPath) {
        if let cell = viewRoot.viewTable.cellForRow(at: index) {
            NotificationCenter.default.post(name: .EntriesListNewPoint, object: cell)
        }
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

// MARK: - CellMainDelegate
extension EntriesListController: CellMainDelegate {
    func didLongPressAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = service.entry(at: index)
        else { return }
     
        let alert = createManipulationAlert(for: entry)
        present(alert, animated: true)
    }
    
    func didPressAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = service.entry(at: index)
        else { return }
        
        let pointsList = EntryDetailsController()
        let navigation = UINavigationController(rootViewController: pointsList)
        
        let model = EntryDetailsModel(entry)
        
        // TODO: check if this is okay
        pointsList.model = model
        model.delegate = pointsList
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        
        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.compactAppearance = appearance
        ///
        /// During onboarding this presentation will fail but notification will be handled by `EntriesListOnboardingController`
        ///
        present(navigation, animated: true)
        
        NotificationCenter.default.post(name: .EntriesListDetailsPresentationAttempt, object: navigation)
    }
    
    func didSwipeAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = service.entry(at: index)
        else { return }
        
        cellIndexToBeAnimated = index
        service.addNewPoint(to: entry)
    }
    
    func didAnimation(_ cell: EntryCell) { cellIndexToBeAnimated = nil }
}

// MARK: - Onboarding
extension EntriesListController: EntriesListOnboardingControllerDataSource {
    var viewSwiper: UIView { viewRoot.swiper }
    var viewInput: UIView { viewRoot.input.onboardingHighlight }
}

// MARK: First time launch logic
extension EntriesListController {
    var openedPreviously: Bool { UserDefaults.standard.bool(forKey: "openedPreviously") }
    
    private func startOnboardingForNewUser() {
        guard !openedPreviously else { return }
        UserDefaults.standard.set(true, forKey: "openedPreviously")
        startOnboarding()
    }
}

extension EntriesListController: EntriesListOnboardingControllerDelegate {
    func startOnboarding() {
        let onboarding = EntriesListOnboardingController()
        onboarding.modalPresentationStyle = .overCurrentContext
        onboarding.modalTransitionStyle = .crossDissolve
        onboarding.mainDataSource = self
        onboarding.mainDelegate = self
        onboarding.isModalInPresentation = true
        present(onboarding, animated: true) {
            onboarding.start()
        }
    }
    
    func createTestItem() {
        service.create(filledEntryName: "Demo entry", withDaysAmount: 18)
    }
    
    func prepareForOnboardingStart() {
        viewRoot.swiper.hideSettings()
        viewRoot.input.disableCancelButton()
        
        setupModel(with: coreDataStack.onboardingContext)
    }
    
    func prepareForOnboardingEnd() {
        viewRoot.swiper.showSettings()
        viewRoot.input.enableCancelButton()
        
        coreDataStack.resetOnboardingContainer()
        
        setupModel(with: coreDataStack.defaultContext)
    }
    
    private func setupModel(with moc: NSManagedObjectContext) {
        let model = EntriesListService(moc: moc, stack: coreDataStack)
        service = model
        model.delegate = self
        model.fetch()
        viewRoot.viewTable.reloadData()
    }
}

// MARK: - Notifications
extension Notification.Name {
    static let EntriesListNewEntry = Notification.Name(rawValue: "EntriesListNewEntry")
    static let EntriesListNewPoint = Notification.Name(rawValue: "EntriesListNewPoint")
    static let EntriesListDetailsPresentationAttempt = Notification.Name(rawValue: "EntriesListDetailsPresentationAttempt")
}
