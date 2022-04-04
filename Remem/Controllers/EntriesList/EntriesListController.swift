//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import CoreData
import UIKit

class EntriesListController: UIViewController, EntriesListModelDelegate {
    //
    
    // MARK: - Private properties
    
    //
    
    let viewRoot = EntriesListView()
    
    var model: EntriesListModelInterface!
    
    fileprivate var cellIndexToBeAnimated: IndexPath?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        setupTableView()
        
        setupEventHandlers()
        
        configureInputAccessoryView()
        
        model.fetchEntries()
    }
    
    fileprivate func setupTableView() {
        viewRoot.viewTable.dataSource = self
        viewRoot.viewTable.delegate = self
    }
    
    //

    // MARK: - Events handling

    //
    
    fileprivate func setupEventHandlers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        viewRoot.input.delegate = self
        
        viewRoot.viewInputBackground.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleViewInputBackgroundTap)))
        
        viewRoot.swiper.addTarget(self, action: #selector(handleSwiperSelection), for: .primaryActionTriggered)
    }
    
    @objc fileprivate func handleSwiperSelection(_ sender: UISwipingSelector) {
        guard let selectedOption = sender.value else { return }
        switch selectedOption {
        case .addEntry:
            showInput()
        case .settings:
            presentSettings()
        }
    }
    
    fileprivate func createManipulationAlert(for entry: Entry) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.model.remove(entry: entry)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    //
    // Settings selection handling
    //
    
    fileprivate func presentSettings() {
        let controller = SettingsController()
        let navigation = UINavigationController(rootViewController: controller)
        
        present(navigation, animated: true, completion: nil)
    }
    
    //

    // MARK: - Public methods

    //
    
    func startOnboarding() {
        let onboarding = EntriesListOnboardingController()
        onboarding.modalPresentationStyle = .overCurrentContext
        onboarding.mainDataSource = self
        onboarding.mainDelegate = self
        onboarding.isModalInPresentation = true
        present(onboarding, animated: true)
    }
}

//

// MARK: - UITableViewDataSource

//

extension EntriesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataAmount = model.dataAmount
        
        if dataAmount == 0 {
            viewRoot.showEmptyState()
        } else {
            viewRoot.hideEmptyState()
        }
        
        return dataAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: EntryCell.reuseIdentifier) as? EntryCell,
            let dataRow = model.entry(at: indexPath)
        else { return UITableViewCell() }
        
        row.delegate = self
        row.update(name: dataRow.name!)
        row.update(value: dataRow.totalAmount)
        
        return row
    }
}

//

// MARK: NSFetchedResultsControllerDelegate

//

extension EntriesListController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewTable.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        viewRoot.viewTable.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let insertIndex = newIndexPath else { return }
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
}

//

// MARK: - UITableViewDelegate

//

extension EntriesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = cellIndexToBeAnimated, index == indexPath {
            let cell = cell as! EntryCell
            
            cell.animateMovableViewBack()
        }
        
        // TODO: make this condition to be good
        /// what if there are more cells than screen can fit?
        let cellIsNew = tableView.visibleCells.firstIndex(of: cell) == nil
        
        if cellIsNew {
            NotificationCenter.default.post(name: .ControllerMainItemCreated, object: cell)
        }
    }
}

//

// MARK: UIScrollViewDelegate

//

extension EntriesListController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewRoot.swiper.handleScrollView(contentOffset: scrollView.contentOffset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewRoot.swiper.handleScrollViewDraggingEnd()
    }
}

//

// MARK: - CellMainDelegate

//

extension EntriesListController: CellMainDelegate {
    func didLongPressAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = model.entry(at: index)
        else { return }
        
        let alert = createManipulationAlert(for: entry)
        
        present(alert, animated: true)
    }
    
    // TODO: fix EntryDetailsController
    func didPressAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = model.entry(at: index)
        else { return }
        
        let pointsList = EntryDetailsController(entry: entry)
        let navigation = UINavigationController(rootViewController: pointsList)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.configureWithOpaqueBackground()
        appearance.shadowImage = nil
        appearance.shadowColor = .clear
        
        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.compactAppearance = appearance
        present(navigation, animated: true)
    }
    
    func didSwipeAction(_ cell: EntryCell) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = model.entry(at: index)
        else { return }
        
        cellIndexToBeAnimated = index
        model.addNewPoint(to: entry)
    }
    
    //
    
    func didAnimation(_ cell: EntryCell) {
        cellIndexToBeAnimated = nil
    }
}

//

// MARK: - UITextFieldDelegate

//

extension EntriesListController: UITextViewDelegate {
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFutureOrigin = keyboardSize.cgRectValue.origin.y

        let keyboardFutureHeight = .hScreen - keyboardFutureOrigin
        
        let height = -keyboardFutureHeight - .d2 - .delta1
        
        UIView.animate(withDuration: EntriesListOnboardingController.standartDuration, delay: 0.0, options: .curveEaseInOut, animations: {
            if keyboardFutureHeight != 0 {
                self.viewRoot.inputContainerConstraint.constant = height
            } else {
                self.viewRoot.inputContainerConstraint.constant = keyboardFutureHeight
            }
            self.viewRoot.layoutIfNeeded()
        }, completion: { animationCompleted in
            if animationCompleted {
                NotificationCenter.default.post(name: .ControllerMainAddItemTriggered, object: nil)
            }
        })
        
        NotificationCenter.default.post(name: .ControllerMainInputConstraintUpdated, object: nil)
    }
    
    @objc private func handlePressAdd() {
        showInput()
    }
    
    @objc func handleViewInputBackgroundTap() {
        hideInput()
        
        viewRoot.input.text = ""
    }
    
    private func showInput() {
        showInputBackground()
        
        viewRoot.input.becomeFirstResponder()
    }
    
    private func configureInputAccessoryView() {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: .wScreen, height: 44))
        
        let dismiss = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(handleViewInputBackgroundTap))
        
        let icon01 = UIBarButtonItem(title: "☕️", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon02 = UIBarButtonItem(title: "💊", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon03 = UIBarButtonItem(title: "👟", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon04 = UIBarButtonItem(title: "📖", style: .plain, target: self, action: #selector(handleEmojiPress))
        let icon05 = UIBarButtonItem(title: "🚬", style: .plain, target: self, action: #selector(handleEmojiPress))
        
        let spaceLeft = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceRight = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let create = UIBarButtonItem(title: "Add",
                                     style: .plain,
                                     target: self,
                                     action: #selector(handleCreate))
        
        bar.items = [
            dismiss,
            spaceLeft,
            icon01,
            icon02,
            icon03,
            icon04,
            icon05,
            spaceRight,
            create,
        ]
        
        bar.sizeToFit()
        
        viewRoot.input.inputAccessoryView = bar
    }
    
    @objc private func handleEmojiPress(_ barItem: UIBarButtonItem) {
        viewRoot.input.text += barItem.title ?? ""
    }
    
    @objc private func handleCreate() {
        model.create(entryName: viewRoot.input.text)
        
        hideInput()
    }
    
    private func showInputBackground() {
        viewRoot.viewInputBackground.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.viewInputBackground.alpha = 1
        })
    }
    
    private func hideInputBackground() {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.viewInputBackground.alpha = 0.0
        }, completion: { _ in
            self.viewRoot.viewInputBackground.isHidden = true
        })
    }
    
    fileprivate func hideInput() {
        viewRoot.input.resignFirstResponder()
        hideInputBackground()
        viewRoot.input.text = ""
    }
}

//

// MARK: - Onboarding

//

extension EntriesListController: ControllerMainOnboardingDataSource {
    var viewSwiper: UIView {
        viewRoot.swiper
    }
    
    var viewInput: UIView {
        viewRoot.viewInput
    }
    
    var inputHeightOffset: CGFloat {
        viewRoot.inputContainerConstraint.constant - .delta1
    }
}

extension EntriesListController: ControllerMainOnboardingDelegate {
    func createTestItem() {
        model.create(entryName: "Test10")
    }
    
    func disableSettingsButton() {
        viewRoot.swiper.hideSettings()
    }
    
    func enableSettingsButton() {
        viewRoot.swiper.showSettings()
    }
}
