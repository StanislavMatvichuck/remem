//
//  EventsService.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 12.07.2022.
//

import CoreData

protocol EventsRepositoryInput {
    func allEvents() -> [Event]
    func event(at: Int) -> Event?
    func event(by: String) -> Event?
    func add(name: String)
    func remove(_: Event)

    @discardableResult func addHappening(to: Event, date: Date) -> Happening
}

class EventsRepository {
    private var events: [Event] = []
    private let coreDataStack = CoreDataStack()
    private var moc: NSManagedObjectContext { coreDataStack.defaultContext }
}

// MARK: - Public
extension EventsRepository: EventsRepositoryInput {
    func allEvents() -> [Event] {
        fetch()
        return events
    }

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

    func add(name: String) {
        let newEvent = Event(context: moc)
        newEvent.dateCreated = .now
        newEvent.name = name
        coreDataStack.save(moc)
    }

    func remove(_ event: Event) {
        moc.delete(event)
        coreDataStack.save(moc)
    }

    @discardableResult
    func addHappening(to event: Event, date: Date) -> Happening {
        let newHappening = Happening(context: moc) // creation logic
        newHappening.dateCreated = date // creation logic
        newHappening.event = event // TODO: delete this relation?

        event.happenings?.adding(newHappening) // creation logic

        let isFirstHappening = event.lastHappening == nil
        var isLatestHappening = false

        if let lastDate = event.lastHappening?.dateCreated, lastDate < date {
            isLatestHappening = true
        }

        if isFirstHappening || isLatestHappening {
            event.lastHappening = newHappening // creation logic
        }

        coreDataStack.save(moc)
        return newHappening
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
