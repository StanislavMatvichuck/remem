//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain

public class CoreDataEventsRepository: EventsQuerying, EventsCommanding {
    private let container: NSPersistentContainer
    private let entityMapper: EventEntityMapper
    private var moc: NSManagedObjectContext { container.viewContext }

    public init(
        container: NSPersistentContainer,
        mapper: EventEntityMapper
    ) {
        self.container = container
        self.entityMapper = mapper
    }

    public func get(using sort: EventsQuerySorter) -> [Event] {
        do {
            switch sort {
            case .alphabetical:
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)

                let request = CDEvent.fetchRequest()
                request.sortDescriptors = [sortDescriptor]

                let fetchedCDEvents = try moc.fetch(request)

                return fetchedCDEvents.map { entityMapper.convert($0)! }
            }
        } catch {
            fatalError("unable to fetch events")
        }
    }

    public func get() -> [Event] { allEvents.compactMap { entityMapper.convert($0) } }

    public func save(_ event: Event) {
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

    public func delete(_ event: Event) {
        guard let cdEventToDelete = getById(of: event) else { fatalError("Cant find object to delete") }

        moc.delete(cdEventToDelete)

        applyChanges()
    }

    private var allEvents: [CDEvent] {
        do {
            let request = CDEvent.fetchRequest()
            return try moc.fetch(request)
        } catch {
            fatalError("Unable to fetch events")
        }
    }

    private func getById(of event: Event) -> CDEvent? {
        allEvents.filter {
            self.entityMapper.entityAccessorKey(event) ==
                self.entityMapper.entityAccessorKey($0)
        }.first
    }

    private func applyChanges() {
        if moc.hasChanges {
            do {
                moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try moc.save()
            } catch {
                fatalError(error.localizedDescription)
            }
            print("Saved")
        } else {
            print("No changes to save in repository")
        }
    }
}
