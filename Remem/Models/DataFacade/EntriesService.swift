//
//  EntriesService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class EntriesService {
    private var entries: [Entry] = []
    private let coreDataStack = CoreDataStack()
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension EntriesService {
    func fetch() {
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")

        do {
            entries = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print("Unable to fetch Entries \(error), \(error.userInfo)")
        }
    }

    func getAmount() -> Int { return entries.count }

    func getVisitedAmount() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Entry")
        fetchRequest.resultType = .countResultType

        let predicate = NSPredicate(format: "%K != nil", #keyPath(Entry.dateVisited))
        fetchRequest.predicate = predicate

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("Unable to fetch visited Entries \(error), \(error.userInfo)")
            return 0
        }
    }

    func entry(at index: Int) -> Entry? {
        guard
            index <= entries.count,
            index >= 0
        else { return nil }

        return entries[index]
    }

    func entry(by id: String) -> Entry? {
        fetch()

        return entries.first(where: { entry in
            entry.objectID.uriRepresentation().absoluteString == id
        })
    }

    func make(name: String) -> Entry {
        let newEntry = Entry(context: moc)
        newEntry.name = name
        newEntry.dateCreated = NSDate.now

        coreDataStack.save(moc)

        return newEntry
    }

    func makePoint(at entry: Entry, dateTime: Date) -> Point {
        let newPoint = Point(context: moc)
        newPoint.dateCreated = dateTime
        newPoint.entry = entry

        coreDataStack.save(moc)

        return newPoint
    }

    func delete(_ entry: Entry) {
        moc.delete(entry)
        coreDataStack.save(moc)
    }

    func visit(_ entry: Entry) {
        entry.markAsVisited()
        coreDataStack.save(moc)
    }
}
