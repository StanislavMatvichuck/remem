//
//  EntriesListModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.03.2022.
//

import CoreData
import Foundation
import UIKit.UIApplication

class EntriesListService {
    // MARK: - Properties
    weak var delegate: NSFetchedResultsControllerDelegate?
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
        self.coreDataStack = stack
        self.moc = moc
    }
}

// MARK: - Public
extension EntriesListService {
    func fetch() {
        do { try fetchedResultsController.performFetch() }
        catch { print("fetch request failed") }
    }

    func fetchPointsCount() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Point")
        fetchRequest.resultType = .countResultType

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
            return 0
        }
    }

    func fetchVisitedEntries() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Entry")
        fetchRequest.resultType = .countResultType
        let predicate = NSPredicate(format: "%K != nil", #keyPath(Entry.dateVisited))
        fetchRequest.predicate = predicate

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
            return 0
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
    func create(filledEntryName: String, withDaysAmount: Int) -> Entry {
        let entry = Entry(context: moc)
        entry.name = filledEntryName
        entry.dateCreated = Date.now.days(ago: withDaysAmount)

        for i in 0 ... withDaysAmount {
            let randomAmountOfPointsPerDay = Int.random(in: 1 ... 6)
            for _ in 0 ... randomAmountOfPointsPerDay {
                entry.addDefaultPoint(withDate: Date.now.days(ago: i))
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
        entry.addDefaultPoint()
        coreDataStack.save(moc)
    }
}
