//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import CoreData
import UIKit

class ControllerMain: UIViewController, CoreDataConsumer {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewMain()
    
    fileprivate var cellIndexToBeAnimated: IndexPath?
    
    fileprivate var data: [Entry] = [] {
        didSet {
            viewRoot.viewTable.reloadData()
        }
    }
    
    //
    // CoreData properties
    //
    
    var persistentContainer: NSPersistentContainer!
    
    var fetchedResultsController: NSFetchedResultsController<Entry>?
    var pointsFetchedResultsController: NSFetchedResultsController<Point>?
    
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
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
        
        fetch()
    }
    
    private func setupTableView() {
        viewRoot.viewTable.dataSource = self
        viewRoot.viewTable.delegate = self
    }
    
    private func fetch() {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        
        let pointsRequest = NSFetchRequest<Point>(entityName: "Point")
        
        pointsRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]
        
        pointsFetchedResultsController = NSFetchedResultsController(fetchRequest: pointsRequest,
                                                                    managedObjectContext: moc,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)
        
        pointsFetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            try pointsFetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
    }
    
    //

    // MARK: - Events handling

    //
    
    private func setupEventHandlers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
        
        viewRoot.input.delegate = self
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewInputBackgroundTap))
        
        viewRoot.viewInputBackground.addGestureRecognizer(recognizer)
    }
    
    private func createEntryAndPersistIt() {
        guard let name = viewRoot.input.text, !name.isEmpty else { return }
        
        moc.persist {
            if name.hasPrefix("Test") {
                let index = name.index(name.startIndex, offsetBy: 4)
                
                let parsedDaysAmount = Int(name.suffix(from: index)) ?? 0
                
                self.createTestEntry(daysAmount: parsedDaysAmount, hasData: true)
            } else {
                let entry = Entry(context: self.moc)
                entry.name = name
                entry.dateCreated = NSDate.now
            }
        }
        
        viewRoot.input.text = ""
    }

    private func createTestEntry(daysAmount: Int, hasData: Bool) {
        let entry = Entry(context: moc)
        
        entry.name = "Test\(daysAmount)"
        
        entry.dateCreated = Calendar.current.date(byAdding: .day, value: -daysAmount, to: Date.now)!
        
        if hasData {
            for i in 0 ... daysAmount {
                createTestPoint(for: entry, at: i, amount: Int.random(in: 1 ... 7))
            }
        }
    }
    
    private func createTestPoint(for entry: Entry, at day: Int, amount: Int) {
        for _ in 1 ... amount {
            let point = Point(context: moc)
        
            point.entry = entry
            point.value = 1
            point.dateCreated = Calendar.current.date(byAdding: .day, value: -day, to: Date.now)!
        }
    }
    
    //
    // Shake gesture handling
    //
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            removeLastPoint()
        }
    }
    
    private func removeLastPoint() {
        guard
            let allPoints = pointsFetchedResultsController?.fetchedObjects,
            let allEntries = fetchedResultsController?.fetchedObjects,
            let removedPoint = allPoints.last,
            let removedPointParentEntry = removedPoint.entry
        else { return }
        
        moc.persist(block: {
            self.moc.delete(removedPoint)
        }) {
            guard
                let entryIndex = allEntries.firstIndex(of: removedPointParentEntry),
                let cell = self.viewRoot.viewTable.cellForRow(at: IndexPath(row: entryIndex, section: 0)) as? CellMain
            else { return }
            
            cell.animateTotalAmountDecrement()
            UIDevice.vibrate(.medium)
        }
    }
}

//

// MARK: - UITableViewDataSource

//

extension ControllerMain: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataAmount = fetchedResultsController?.fetchedObjects?.count ?? 0
        
        if dataAmount == 0 {
            viewRoot.showEmptyState()
        } else {
            viewRoot.hideEmptyState()
        }
        
        return dataAmount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: CellMain.reuseIdentifier) as? CellMain,
            let dataRow = fetchedResultsController?.object(at: indexPath)
        else { return UITableViewCell() }

        row.delegate = self
        row.update(name: dataRow.name!)
        row.update(value: dataRow.totalAmount)
        
        return row
    }
}

//

// MARK: - UITableViewDelegate

//

extension ControllerMain: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = cellIndexToBeAnimated, index == indexPath {
            let cell = cell as! CellMain
            
            cell.animateMovableViewBack()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newContentOffset = 3 * scrollView.contentOffset.y
    
        viewRoot.fillerConstraint.constant = -newContentOffset.clamped(to: -(UIScreen.main.bounds.width - .xs) ... 0)
        
        let screenThird = UIScreen.main.bounds.width / 3

        if -newContentOffset >= 2 * screenThird + CellMain.r2 {
            viewRoot.animateViewCreatePointSelectedState(to: true)
        } else {
            viewRoot.animateViewCreatePointSelectedState(to: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let newContentOffset = -3 * scrollView.contentOffset.y
        
        let screenThird = UIScreen.main.bounds.width / 3
    
        if newContentOffset >= 2 * screenThird + CellMain.r2 {
            handlePressAdd()
        }
    }
}

//

// MARK: - CellMainDelegate

//

extension ControllerMain: CellMainDelegate {
    func didLongPressAction(_ cell: CellMain) {
        guard
            let index = viewRoot.viewTable.indexPath(for: cell),
            let entry = fetchedResultsController?.fetchedObjects?[index.row]
        else { return }
        
        present(createManipulationAlert(for: entry), animated: true, completion: nil)
    }
    
    private func createManipulationAlert(for entry: Entry) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View list", style: .default, handler: { _ in
            self.present(self.createControllerPointList(for: entry), animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.delete(entry: entry)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    private func createControllerPointList(for entry: Entry) -> UIViewController {
        let controller = ControllerPointsList(entry: entry)
            
        controller.persistentContainer = persistentContainer
            
        let navigator = UINavigationController(rootViewController: controller)
        
        return navigator
    }
    
    private func delete(entry: Entry) {
        moc.persist {
            self.moc.delete(entry)
        } successBlock: {
            UIDevice.vibrate(.medium)
        }
    }
    
    func didSwipeAction(_ cell: CellMain) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        
        cellIndexToBeAnimated = index
        
        guard let managedObjects = fetchedResultsController?.fetchedObjects else { return }
        
        let entry = managedObjects[index.row]
        
        add(point: createPoint(), to: entry)
    }
    
    private func createPoint() -> Point {
        let point = Point(context: moc)
        
        point.dateCreated = NSDate.now
        point.value = 1
        
        return point
    }
    
    private func add(point: Point, to entry: Entry) {
        moc.persist {
            let newPoints: Set<AnyHashable> = entry.points?.adding(point) ?? [point]
            
            entry.points = NSSet(set: newPoints)
        } successBlock: {
            UIDevice.vibrate(.medium)
        }
    }
    
    func didAnimation(_ cell: CellMain) {
        cellIndexToBeAnimated = nil
    }
}

//

// MARK: - NSFetchedResultsControllerDelegate

//

extension ControllerMain: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchedResultsController {
            viewRoot.viewTable.beginUpdates()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == fetchedResultsController {
            viewRoot.viewTable.endUpdates()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?)
    {
        if controller == fetchedResultsController {
            switch type {
            case .insert:
                guard let insertIndex = newIndexPath else { return }
                viewRoot.viewTable.insertRows(at: [insertIndex], with: .automatic)
            case .delete:
                guard let deleteIndex = indexPath else { return }
                viewRoot.viewTable.deleteRows(at: [deleteIndex], with: .automatic)
            case .move:
                guard let fromIndex = indexPath, let toIndex = newIndexPath
                else { return }
                viewRoot.viewTable.moveRow(at: fromIndex, to: toIndex)
            case .update:
                guard let updateIndex = indexPath else { return }
                viewRoot.viewTable.reloadRows(at: [updateIndex], with: .none)
            @unknown default:
                fatalError("Unhandled case")
            }
        }
    }
}

//

// MARK: - UITextFieldDelegate

//

extension ControllerMain: UITextViewDelegate {
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFutureOrigin = keyboardSize.cgRectValue.origin.y

        let keyboardFutureHeight = .hScreen - keyboardFutureOrigin
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            if keyboardFutureHeight != 0 {
                self.viewRoot.inputContainerConstraint.constant = -keyboardFutureHeight - 2 * CellMain.r2 - .xs
            } else {
                self.viewRoot.inputContainerConstraint.constant = keyboardFutureHeight
            }
            self.viewRoot.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func handlePressAdd() {
        showInput()
    }
    
    @objc func handleViewInputBackgroundTap() {
        hideInput()
        
        viewRoot.input.text = ""
    }
    
    private func showInput() {
        viewRoot.viewInputBackground.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.viewInputBackground.alpha = 1
        })
        
        let bar = UIToolbar()
        let create = UIBarButtonItem(title: "Create",
                                     style: .plain,
                                     target: self,
                                     action: #selector(handleCreate))
        
        let dismiss = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(handleViewInputBackgroundTap))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [dismiss, space, create]
        bar.sizeToFit()
        viewRoot.input.inputAccessoryView = bar
        
        viewRoot.input.becomeFirstResponder()
    }
    
    @objc private func handleCreate() {
        hideInput()
        
        // TODO: remove this mess!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.createEntryAndPersistIt()
        }
    }
    
    @objc private func hideInput() {
        viewRoot.input.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.viewInputBackground.alpha = 0.0
        }, completion: { _ in
            self.viewRoot.viewInputBackground.isHidden = true
        })
    }
}
