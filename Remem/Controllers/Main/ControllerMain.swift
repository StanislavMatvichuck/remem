//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import CoreData
import UIKit

class ControllerMain: UIViewController, UITextFieldDelegate, CoreDataConsumer {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewMain()
    
    fileprivate var textField = UITextField()
    
    fileprivate var cellIndexToBeAnimated: IndexPath?
    
    fileprivate var data: [Entry] = [] {
        didSet {
            viewRoot.viewTable.reloadData()
        }
    }
    
    var persistentContainer: NSPersistentContainer!
    
    var fetchedResultsController: NSFetchedResultsController<Entry>?
    var pointsFetchedResultsController: NSFetchedResultsController<Point>?
    
    //
    
    // MARK: - Initialization
    
    //
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        viewRoot.viewTable.dataSource = self
        viewRoot.viewTable.delegate = self
        textField.delegate = self
        
        fetch()
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        title = "Remem"
        
        //
        // Right temporary button
        //
        
        let addImage = UIImage(systemName: "plus")?
            .withTintColor(.orange)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))
        
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(handlePressAdd))
        
        navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    private func fetch() {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        
        let moc = persistentContainer.viewContext
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController?.delegate = self
        
        let pointsRequest = NSFetchRequest<Point>(entityName: "Point")
        
        pointsRequest.sortDescriptors = [NSSortDescriptor(key: "dateTime", ascending: true)]
        
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
    
    @objc private func handlePressAdd() {
        let alert = UIAlertController(title: "New entry", message: "Give your event a name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: handlePressAddConfirm)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
            
        alert.addTextField { textField in
            self.textField = textField
        }
            
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handlePressAddConfirm(_: UIAlertAction) {
        guard let name = textField.text, !name.isEmpty else { return }
        
        let moc = persistentContainer.viewContext
        
        moc.perform {
            let entry = Entry(context: moc)
            entry.name = name
            do {
                try moc.save()
            } catch {
                moc.rollback()
            }
        }
    }
    
    //
    // Shake gesture handling
    //
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let moc = persistentContainer.viewContext
            
            guard let managedObjects = pointsFetchedResultsController?.fetchedObjects else { return }
            
            moc.perform {
                guard !managedObjects.isEmpty else { return }
                
                moc.delete(managedObjects.last!)
                
                do {
                    try moc.save()
                    UIDevice.vibrate(.medium)
                } catch {
                    moc.rollback()
                }
            }
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
            viewRoot.animatePointSelector()
        } else {
            viewRoot.reversePointSelectorAnimation()
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
    //
    // Long press Entry deletion
    //
    
    func didLongPressAction(_ cell: CellMain) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "View list", style: .default, handler: { _ in
            let controller = ControllerPointsList()
            
            controller.persistentContainer = self.persistentContainer
            
//            let moc = self.persistentContainer.viewContext
            
//            let entry = self.fetchedResultsController?.fetchedObjects?[index.row]
            
//            dump(entry)
            
            self.present(controller, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete row", style: .destructive, handler: { _ in
            self.deleteRowBy(index: index)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteRowBy(index: IndexPath) {
        let moc = persistentContainer.viewContext
        
        guard let managedObjects = fetchedResultsController?.fetchedObjects else { return }

        moc.perform {
            guard !managedObjects.isEmpty else { return }
            
            moc.delete(managedObjects[index.row])
            
            do {
                try moc.save()
                
                UIDevice.vibrate(.medium)
            } catch {
                moc.rollback()
            }
        }
    }
    
    func didSwipeAction(_ cell: CellMain) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        
        cellIndexToBeAnimated = index
        
        guard let managedObjects = fetchedResultsController?.fetchedObjects else { return }
        
        let moc = persistentContainer.viewContext
        
        moc.perform {
            let newPoint = Point(context: moc)
            
            newPoint.dateTime = NSDate.now
            newPoint.value = 1
            
            let newFavorites: Set<AnyHashable> = managedObjects[index.row].points?.adding(newPoint) ?? [newPoint]
            
            let entry = managedObjects[index.row]
            
            entry.points = NSSet(set: newFavorites)
            do {
                try moc.save()
                UIDevice.vibrate(.medium)
            } catch {
                moc.rollback()
            }
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
