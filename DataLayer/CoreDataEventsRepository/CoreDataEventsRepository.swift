//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain
import os

public struct CoreDataEventsRepository {
    enum RepositoryError: Error { case asyncReadingNil }

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

    public func identifiers() -> [String] { do {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Event")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["uuid"]
        return try moc.fetch(fetchRequest).map { $0.allValues.first } as! [String]
    } catch {
        fatalError(error.localizedDescription)
    } }

    public func readAsync(byId: String) async throws -> Event {
        let backgroundContext = container.newBackgroundContext()

        let cdEvent = try await backgroundContext.perform {
            let request = CDEvent.fetchRequest()
            let predicate = NSPredicate(format: "uuid == %@", byId)
            request.predicate = predicate
            return try request.execute().first
        }

        try Task.checkCancellation()

        if let cdEvent {
            return try await EventCoreDataMapper.convert(cdEvent: cdEvent)
        } else { throw RepositoryError.asyncReadingNil }
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
