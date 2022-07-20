//
//  EventsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

class EventsRepository {
    private var events: [Event] = []
    private let coreDataStack = CoreDataStack()
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension EventsRepository {
    func getAmount() -> Int { return events.count }

    func event(at index: Int) -> Event? {
        guard
            index <= events.count,
            index >= 0
        else { return nil }

        return events[index]
    }

    func event(by id: String) -> Event? {
        fetch()

        return events.first(where: { event in
            event.objectID.uriRepresentation().absoluteString == id
        })
    }

    @discardableResult
    func make(name: String) -> Event {
        let newEvent = Event(context: moc)
        newEvent.name = name
        newEvent.dateCreated = NSDate.now

        coreDataStack.save(moc)

        return newEvent
    }

    @discardableResult
    func makeHappening(at event: Event, dateTime: Date) -> Happening {
        let newHappening = Happening(context: moc)
        newHappening.dateCreated = dateTime
        newHappening.event = event

        event.lastHappening = newHappening

        coreDataStack.save(moc)

        return newHappening
    }

    func delete(_ event: Event) {
        moc.delete(event)
        coreDataStack.save(moc)
    }

    func visit(_ event: Event) {
        event.dateVisited = .now
        coreDataStack.save(moc)
    }

    func getList() -> [Event] {
        fetch()
        return events
    }
}

// MARK: - Private
extension EventsRepository {
    private func fetch() {
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            events = try moc.fetch(fetchRequest)
        } catch let error as NSError {
            print("Unable to fetch Events \(error), \(error.userInfo)")
        }
    }
}
