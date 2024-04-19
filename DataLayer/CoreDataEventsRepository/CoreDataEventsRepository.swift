//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain

public class CoreDataEventsRepository {
    private let container: NSPersistentContainer
    private var moc: NSManagedObjectContext { container.viewContext }

    public init(container: NSPersistentContainer) { self.container = container }

    private func applyChanges() {
        do {
            if moc.hasChanges {
                moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try moc.save()
                print("CoreDataEventsRepository.applyChanges")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func cdEvent(id: String) -> CDEvent? { do {
        let request = CDEvent.fetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", id)
        request.predicate = predicate
        return try moc.fetch(request).first
    } catch {
        fatalError("Event not found in a context")
    } }
}

extension CoreDataEventsRepository: EventsReading {
    public func read() -> [Event] { do {
        let request = CDEvent.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let cdEvents = try moc.fetch(request)
        return cdEvents.map { EventCoreDataMapper.convert(cdEvent: $0) }
    } catch {
        fatalError("Unable to fetch events")
    } }

    public func read(byId: String) -> Event {
        if let cdEvent = cdEvent(id: byId) {
            return EventCoreDataMapper.convert(cdEvent: cdEvent)
        } else {
            fatalError("Unable to find CDEvent by id")
        }
    }
}

extension CoreDataEventsRepository: EventsWriting {
    public func create(event: Domain.Event) {
        let newEvent = CDEvent(entity: CDEvent.entity(), insertInto: moc)

        EventCoreDataMapper.update(cdEvent: newEvent, event: event)

        applyChanges()
    }

    public func update(id: String, event: Domain.Event) {
        if let cdEvent = cdEvent(id: id) {
            EventCoreDataMapper.update(cdEvent: cdEvent, event: event)

            applyChanges()
        }
    }

    public func delete(id: String) {
        if let cdEvent = cdEvent(id: id) {
            moc.delete(cdEvent)

            applyChanges()
        }
    }
}
