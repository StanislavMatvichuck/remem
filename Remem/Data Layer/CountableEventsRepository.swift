//
//  CountableEventsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class CountableEventsRepository {
    private var entries: [CountableEvent] = []
    private let coreDataStack = CoreDataStack()
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension CountableEventsRepository {
    func fetch() {
        let fetchRequest = NSFetchRequest<CountableEvent>(entityName: "CountableEvent")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            entries = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print("Unable to fetch CountableEvents \(error), \(error.userInfo)")
        }
    }

    func getAmount() -> Int { return entries.count }

    func getVisitedAmount() -> Int {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "CountableEvent")
        fetchRequest.resultType = .countResultType

        let predicate = NSPredicate(format: "%K != nil", #keyPath(CountableEvent.dateVisited))
        fetchRequest.predicate = predicate

        do {
            let countResult = try moc.fetch(fetchRequest)
            let count = countResult.first?.intValue ?? 0
            return count
        } catch let error as NSError {
            print("Unable to fetch visited CountableEvents \(error), \(error.userInfo)")
            return 0
        }
    }

    func countableEvent(at index: Int) -> CountableEvent? {
        guard
            index <= entries.count,
            index >= 0
        else { return nil }

        return entries[index]
    }

    func countableEvent(by id: String) -> CountableEvent? {
        fetch()

        return entries.first(where: { countableEvent in
            countableEvent.objectID.uriRepresentation().absoluteString == id
        })
    }

    func make(name: String) -> CountableEvent {
        let newCountableEvent = CountableEvent(context: moc)
        newCountableEvent.name = name
        newCountableEvent.dateCreated = NSDate.now

        coreDataStack.save(moc)

        return newCountableEvent
    }

    func makeCountableEventHappeningDescription(at countableEvent: CountableEvent, dateTime: Date) -> CountableEventHappeningDescription {
        let newCountableEventHappeningDescription = CountableEventHappeningDescription(context: moc)
        newCountableEventHappeningDescription.dateCreated = dateTime
        newCountableEventHappeningDescription.event = countableEvent

        coreDataStack.save(moc)

        return newCountableEventHappeningDescription
    }

    func delete(_ countableEvent: CountableEvent) {
        moc.delete(countableEvent)
        coreDataStack.save(moc)
    }

    func visit(_ countableEvent: CountableEvent) {
        countableEvent.markAsVisited()
        coreDataStack.save(moc)
    }
}
