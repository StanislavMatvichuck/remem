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
        do {
            try fetchedResultsController?.performFetch()
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
            entry.value = 0
            do {
                try moc.save()
            } catch {
                moc.rollback()
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
        row.update(value: Int(dataRow.value))
        
        return row
    }
}

extension ControllerMain: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let index = cellIndexToBeAnimated, index == indexPath {
            let cell = cell as! CellMain
            
            cell.animateMovableViewBack()
        }
    }
}

//

// MARK: - CellMainDelegate

//

extension ControllerMain: CellMainDelegate {
    func didSwipeAction(_ cell: CellMain) {
        guard let index = viewRoot.viewTable.indexPath(for: cell) else { return }
        
        cellIndexToBeAnimated = index
        
        guard let managedObjects = fetchedResultsController?.fetchedObjects else { return }
        let moc = persistentContainer.viewContext
        moc.perform {
            managedObjects[index.row].value += 1
            do {
                try moc.save()
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
            guard let fromIndex = indexPath, let toIndex = newIndexPath
            else { return }
            viewRoot.viewTable.moveRow(at: fromIndex, to: toIndex)
        case .update:
            guard let updateIndex = indexPath else { return }
            viewRoot.viewTable.reloadRows(at: [updateIndex], with: .automatic)
        @unknown default:
            fatalError("Unhandled case")
        }
    }
}
