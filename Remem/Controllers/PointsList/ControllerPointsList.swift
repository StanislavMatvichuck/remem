//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData
import UIKit

class ControllerPointsList: UIViewController, CoreDataConsumer {
    //

    // MARK: - Public properties

    //
    var data = NSSet()
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewPointsList()
    
    var persistentContainer: NSPersistentContainer!
    
    var fetchedResultsController: NSFetchedResultsController<Point>?
    
    var moc: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var relatedEntry: Entry
    
    //
    // Display data types
    //
    
    var dataSize: Int
    
    var headSize: Int
    
    var tailSize: Int
    
    var totalCellsAmount: Int {
        headSize + dataSize + tailSize
    }
    
    lazy var pointsGroupedByDay: [Int] = {
        let allPoints = fetchedResultsController?.fetchedObjects ?? []
        
        var result = [Int](repeating: 0, count: dataSize)
        
        for point in allPoints {
            let pointDate = point.dateCreated!
            
            let pointIndex = (Date.now - pointDate).day!
            
            result[pointIndex] += 1
        }
        
        return result.reversed()
    }()
    
    //
    
    // MARK: - Initialization
    
    //
    
    init(entry: Entry) {
        relatedEntry = entry
        
        let dateCreated = relatedEntry.dateCreated!
        
        let dateToday = Date.now
        
        let dateDelta = dateToday - dateCreated
        
        dataSize = {
            (dateDelta.day ?? 0) + 1
        }()
        
        headSize = {
            if dateCreated.weekdayNumber.rawValue == 1 {
                return 6
            }
            
            return dateCreated.weekdayNumber.rawValue - 2
        }()
        
        tailSize = {
            if dateToday.weekdayNumber.rawValue == 1 {
                return 0
            }
            
            return 8 - dateToday.weekdayNumber.rawValue
            
        }()
        
        super.init(nibName: nil, bundle: nil)
        
        viewRoot.viewTable.dataSource = self
        
        viewRoot.viewDisplay.dataSource = self
        viewRoot.viewDisplay.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        title = relatedEntry.name
        
        fetch()
        
        setupViewStats()
    }
    
    var scrollHappened = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !scrollHappened else { return }
        
        let lastCellIndex = IndexPath(row: totalCellsAmount - 1, section: 0)
        
        viewRoot.viewDisplay.scrollToItem(at: lastCellIndex, at: .right, animated: false)
        
        scrollHappened = true
    }
    
    private func fetch() {
        let request = NSFetchRequest<Point>(entityName: "Point")
        
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        let predicate = NSPredicate(format: "entry == %@", argumentArray: [relatedEntry])
        
        request.predicate = predicate
        
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
    
    private func setupViewStats() {
        let viewDayAverage = ViewStatDisplay(value: relatedEntry.dayAverage, description: "Day average")
        let viewWeekAverage = ViewStatDisplay(value: relatedEntry.weekAverage, description: "Week average")
        let viewLastWeekTotal = ViewStatDisplay(value: Float(relatedEntry.lastWeekTotal), description: "Last week total")
        let viewThisWeekTotal = ViewStatDisplay(value: Float(relatedEntry.thisWeekTotal), description: "This week total")
        let viewPlaceholder = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        viewRoot.viewStats.contain(views: viewDayAverage, viewWeekAverage, viewLastWeekTotal, viewThisWeekTotal, viewPlaceholder)
    }
}

//

// MARK: - UITableViewDataSource

//

extension ControllerPointsList: UITableViewDataSource {
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
            let row = tableView.dequeueReusableCell(withIdentifier: CellPoint.reuseIdentifier) as? CellPoint,
            let dataRow = fetchedResultsController?.object(at: indexPath)
        else { return UITableViewCell() }

        row.update(time: dataRow.time, day: dataRow.timeSince)
        
        return row
    }
}

//

// MARK: - NSFetchedResultsControllerDelegate

//

extension ControllerPointsList: NSFetchedResultsControllerDelegate {
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
            viewRoot.viewTable.reloadRows(at: [updateIndex], with: .none)
        @unknown default:
            fatalError("Unhandled case")
        }
    }
}

//

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

//

extension ControllerPointsList: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCellsAmount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellDay.reuseIdentifier, for: indexPath) as! CellDay
        
        let index = indexPath.row
        
        let numberInMonth = dayInMonth(by: index)
        
        switch cellType(by: index) {
        case .past:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        case .created:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        case .data:
            let isToday = index == totalCellsAmount - tailSize - 1
            
            cell.update(day: "\(numberInMonth)", isToday: isToday)
            if !pointsGroupedByDay.isEmpty {
                let safeDataIndex = index - headSize
                
                cell.update(amount: pointsGroupedByDay[safeDataIndex])
            } else {
                cell.update(amount: nil)
            }
        case .today:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        case .future:
            cell.update(day: "\(numberInMonth)")
            cell.update(amount: nil)
        }
        
        return cell
    }
    
    private func cellType(by index: Int) -> CellDay.type {
        if headSize == 0, index == 0 {
            return .data
        }
        
        if index < headSize - 1 {
            return .past
        }
        
        if index < headSize {
            return .created
        }
        
        if index == totalCellsAmount - tailSize {
            return .today
        }
        
        if index > totalCellsAmount - tailSize {
            return .future
        }
        
        return .data
    }
    
    private func dayInMonth(by index: Int) -> Int {
        let todayIndex = totalCellsAmount - tailSize - 1
        
        let today = Date.now
        
        let daysDelta = todayIndex - index
        
        let nextDate = Calendar.current.date(byAdding: .day, value: -daysDelta, to: today)!
        
        let nextDay = Calendar.current.dateComponents([.day], from: nextDate).day!
        
        return nextDay
    }
}
