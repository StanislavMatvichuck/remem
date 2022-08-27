//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData

class CoreDataEventsRepository {
    private let container: NSPersistentContainer
    private let entityMapper: EntityMapper<Event, CDEvent>
    private var moc: NSManagedObjectContext { container.viewContext }

    // MARK: - Init
    init(container: NSPersistentContainer, mapper: EntityMapper<Event, CDEvent>) {
        self.container = container
        self.entityMapper = mapper
    }
}

extension CoreDataEventsRepository: EventsRepositoryInterface {
    func save(_ data: [Event]) {
        var existingObjects: [String: CDEvent] = [:]

        allEvents.forEach {
            let accessor = self.entityMapper.entityAccessorKey($0)
            existingObjects[accessor] = $0
        }

        data.forEach {
            let accessor = self.entityMapper.entityAccessorKey($0)

            let entityForUpdate: CDEvent? =
                existingObjects[accessor] ??
                NSEntityDescription.insertNewObject(forEntityName: "Event", into: moc) as? CDEvent

            guard let entity = entityForUpdate else { return }
            self.entityMapper.update(entity, by: $0)
        }

        applyChanges()
    }

    func save(_ event: Event) {
        if let existingEvent = allEvents.first(where: {
            entityMapper.entityAccessorKey($0) ==
                entityMapper.entityAccessorKey(event)
        }) {
            entityMapper.update(existingEvent, by: event)
        } else {
            let newCdEvent = CDEvent(context: moc)
            entityMapper.update(newCdEvent, by: event)
        }

        applyChanges()
    }

    func all() -> [Event] {
        let request = CDEvent.fetchRequest()

        do {
            return try moc.fetch(request).compactMap { entityMapper.convert($0) }
        } catch {
            print("Cant fetch events")
            return []
        }
    }

    func event(byId: String) -> Event? {
        guard let existingEvent = allEvents.first(where: {
            entityMapper.entityAccessorKey($0) == byId
        }) else { return nil }

        return entityMapper.convert(existingEvent)
    }

    func delete(_ event: Event) {
        let request = CDEvent.fetchRequest()

        do {
            let allCdEvents = try moc.fetch(request)
            guard
                let cdEventToDelete = allCdEvents.filter({ self.entityMapper.entityAccessorKey($0) == self.entityMapper.entityAccessorKey(event) })
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
    private var allEvents: [CDEvent] {
        let request = CDEvent.fetchRequest()

        do {
            return try moc.fetch(request)
        } catch {
            fatalError("Unable to fetch events")
        }
    }

    private func applyChanges() {
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        switch moc.hasChanges {
        case true:
            do {
                try moc.save()
            } catch {
                fatalError("")
            }
            print("Saved")
        case false:

            print("No changes to save in repository")
        }
    }
}
