//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData

protocol EventsRepositoryInterface {
    func save(_: DomainEvent)
    func save(_: [DomainEvent])
    func all() -> [DomainEvent]
    func delete(_: DomainEvent)
}

class CoreDataEventsRepository {
    private let stack = CoreDataStack()
    private let entityMapper = EventEntityMapper()
    private var moc: NSManagedObjectContext { stack.defaultContext }
}

extension CoreDataEventsRepository: EventsRepositoryInterface {
    func save(_ data: [DomainEvent]) {
        var existingObjects: [String: Event] = [:]

        allEvents.forEach {
            let accessor = self.entityMapper.entityAccessorKey($0)
            existingObjects[accessor] = $0
        }

        data.forEach {
            let accessor = self.entityMapper.entityAccessorKey($0)
            // 3
            let entityForUpdate: Event? =
                existingObjects[accessor] ??
                NSEntityDescription.insertNewObject(forEntityName: "Event", into: moc) as? Event
            // 4
            guard let entity = entityForUpdate else { return }
            self.entityMapper.update(entity, by: $0)
        }
        // 5
        applyChanges()
    }

    func save(_ event: DomainEvent) {
        if let existingEvent = allEvents.first(where: {
            entityMapper.entityAccessorKey($0) ==
                entityMapper.entityAccessorKey(event)
        }) {
            entityMapper.update(existingEvent, by: event)
        } else {
            let newCdEvent = Event(context: moc)
            entityMapper.update(newCdEvent, by: event)
        }

        applyChanges()
    }

    func all() -> [DomainEvent] {
        let request = Event.fetchRequest()

        do {
            return try moc.fetch(request).compactMap { entityMapper.convert($0) }
        } catch {
            print("Cant fetch events")
            return []
        }
    }

    func delete(_ event: DomainEvent) {
        let request = Event.fetchRequest()

        do {
            let allCdEvents = try moc.fetch(request)
            guard
                let cdEventToDelete = allCdEvents.filter({ self.entityMapper.entityAccessorKey($0) == event.id })
                .first
            else { fatalError("Cant find object to delete") }

            moc.delete(cdEventToDelete)

            applyChanges()
        } catch {
            print("Cant fetch events to delete")
        }
    }
}

// MARK: - Private
extension CoreDataEventsRepository {
    private var allEvents: [Event] {
        let request = Event.fetchRequest()

        do {
            return try moc.fetch(request)
        } catch {
            fatalError("Unable to fetch events")
        }
    }

    private func applyChanges() {
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // print("\n\n")
        // print("applyChanges moc registered objects")
        // print(moc.registeredObjects)

        // print("\n\n")
        // print("applyChanges moc updated objects")
        // print(moc.updatedObjects)
        
        // print("\n\n")
        // print("applyChanges moc deleted objects")
        // print(moc.deletedObjects)
        
        // print("\n\n")
        // print("applyChanges moc inserted objects")
        // print(moc.insertedObjects)

        switch moc.hasChanges {
        case true:
            do {
                // 2
                try moc.save()
            } catch {
                fatalError("")
            }
            print("Saved")
        case false:
            // 3
            print("No changes to save in repository")
        }
    }
}
