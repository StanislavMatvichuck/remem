//
//  EntriesListModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.03.2022.
//

import CoreData
import Foundation
import UIKit

protocol EntriesListModelInterface {
    var delegate: EntriesListModelDelegate? { get set }

    var dataAmount: Int { get }

    func fetchEntries()

    func entry(at: IndexPath) -> Entry?
    func create(entryName: String)
    func remove(entry: Entry)

    func addNewPoint(to: Entry)
}

protocol EntriesListModelDelegate: NSFetchedResultsControllerDelegate {}

//

// MARK: - Class definition

//

class EntriesListModel: EntriesListModelInterface, CoreDataConsumer {
    //

    // MARK: - Public properties

    //

    weak var delegate: EntriesListModelDelegate?

    var dataAmount: Int {
        fetchedResultsController?.fetchedObjects?.count ?? 0
    }

    //

    // MARK: Private properties

    //

    //
    // CoreData properties
    //

    internal var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    fileprivate var fetchedResultsController: NSFetchedResultsController<Entry>?

    fileprivate var moc: NSManagedObjectContext { persistentContainer.viewContext }

    //

    // MARK: - Internal behaviour

    //

    fileprivate func createTestEntry(daysAmount: Int, hasData: Bool) {
        let entry = Entry(context: moc)

        entry.name = "Test\(daysAmount)"

        entry.dateCreated = Calendar.current.date(byAdding: .day, value: -daysAmount, to: Date.now)!

        if hasData {
            for i in 0 ... daysAmount {
                createTestPoint(for: entry, at: i, amount: Int.random(in: 1 ... 7))
            }
        }
    }

    fileprivate func createTestPoint(for entry: Entry, at day: Int, amount: Int) {
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

    private func add(point: Point, to entry: Entry) {
        moc.persist {
            let newPoints: Set<AnyHashable> = entry.points?.adding(point) ?? [point]

            entry.points = NSSet(set: newPoints)
        }
    }

    //

    // MARK: - Public behaviour

    //

    func fetchEntries() {
        let request = NSFetchRequest<Entry>(entityName: "Entry")

        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)

        fetchedResultsController?.delegate = delegate

        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("fetch request failed")
        }
    }

    func entry(at: IndexPath) -> Entry? {
        return fetchedResultsController?.object(at: at)
    }

    func create(entryName: String) {
        moc.persist(block: {
            if entryName.hasPrefix("Test") {
                let testOffsetIndex = entryName.index(entryName.startIndex, offsetBy: 4)
                let parsedDaysAmount = Int(entryName.suffix(from: testOffsetIndex)) ?? 0
                self.createTestEntry(daysAmount: parsedDaysAmount, hasData: true)
            } else {
                let entry = Entry(context: self.moc)
                entry.name = entryName
                entry.dateCreated = NSDate.now
            }
        })
    }

    func remove(entry: Entry) {
        moc.persist {
            self.moc.delete(entry)
        }
    }

    func addNewPoint(to: Entry) {
        let point = createPoint()

        add(point: point, to: to)
    }
}
