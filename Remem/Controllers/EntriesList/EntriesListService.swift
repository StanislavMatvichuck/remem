//
//  EntriesListModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.03.2022.
//

import CoreData
import Foundation
import UIKit.UIApplication

protocol EntriesListModelInterface {
    var delegate: EntriesListModelDelegate? { get set }

    var dataAmount: Int { get }
    var moc: NSManagedObjectContext { get }

    func fetch()
    func entry(at: IndexPath) -> Entry?
    @discardableResult func create(entryName: String) -> Entry
    func remove(entry: Entry)
    func addNewPoint(to: Entry)
}

protocol EntriesListModelDelegate: NSFetchedResultsControllerDelegate {
    func newPointAdded(at: IndexPath)
}

class EntriesListService: EntriesListModelInterface {
    // MARK: - Properties
    weak var delegate: EntriesListModelDelegate?
    var dataAmount: Int { fetchedResultsController.fetchedObjects?.count ?? 0 }

    // MARK: CoreData
    let moc: NSManagedObjectContext
    private let coreDataStack: CoreDataStack

    private lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let request = Entry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: moc,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }()

    // MARK: - Init
    init(moc: NSManagedObjectContext, stack: CoreDataStack) {
        self.moc = moc
        self.coreDataStack = stack
    }
}

// MARK: - Internal
extension EntriesListService {
    private func createTestPoint(for entry: Entry, at day: Int, amount: Int) {
        for _ in 1 ... amount {
            let point = Point(context: moc)

            point.entry = entry
            point.value = 1

            var dateCreated = Calendar.current.date(byAdding: .day, value: -day, to: Date.now)!

            dateCreated = Calendar.current.date(byAdding: .hour, value: Int.random(in: 1 ... 24), to: dateCreated)!

            dateCreated = Calendar.current.date(byAdding: .minute, value: Int.random(in: 1 ... 60), to: dateCreated)!

            dateCreated = Calendar.current.date(byAdding: .second, value: Int.random(in: 1 ... 60), to: dateCreated)!

            if dateCreated.timeIntervalSinceNow > 0 {
                point.dateCreated = Date.now
            } else {
                if entry.dateCreated!.timeIntervalSince(dateCreated) > 0 {
                    point.dateCreated = entry.dateCreated!
                } else {
                    point.dateCreated = dateCreated
                }
            }
        }
    }

    private func createPoint() -> Point {
        let point = Point(context: moc)
        point.dateCreated = NSDate.now
        point.value = 1
        return point
    }
}

// MARK: - Public
extension EntriesListService {
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetch request failed")
        }
    }

    func entry(at: IndexPath) -> Entry? { fetchedResultsController.object(at: at) }

    @discardableResult
    func create(entryName: String) -> Entry {
        let newEntry = Entry(context: moc)
        newEntry.name = entryName
        newEntry.dateCreated = NSDate.now
        coreDataStack.save(moc)
        return newEntry
    }

    @discardableResult
    func create(testEntryName: String, withDaysAmount: Int) -> Entry {
        let entry = Entry(context: moc)
        entry.name = testEntryName
        entry.dateCreated = Calendar.current.date(byAdding: .day,
                                                  value: -withDaysAmount,
                                                  to: Date.now)!

        if withDaysAmount > 0 {
            for i in 0 ... withDaysAmount {
                createTestPoint(for: entry, at: i, amount: Int.random(in: 1 ... 7))
            }
        }

        coreDataStack.save(moc)

        return entry
    }

    func remove(entry: Entry) {
        moc.delete(entry)
        coreDataStack.save(moc)
    }

    func addNewPoint(to entry: Entry) {
        let point = createPoint()
        point.entry = entry

        coreDataStack.save(moc)

        if let index = fetchedResultsController.indexPath(forObject: entry) {
            delegate?.newPointAdded(at: index)
        }
    }
}
