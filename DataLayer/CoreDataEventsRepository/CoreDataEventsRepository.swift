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
    private enum EntityName: String { case Event, Happening }

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

    public func identifiers(using ordering: EventsList.Ordering) -> [String] { do {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: "Event")
        fetchRequest.resultType = .dictionaryResultType

        fetchRequest.sortDescriptors = { switch ordering {
        case .name: return [NSSortDescriptor(key: #keyPath(CDEvent.name), ascending: true)]
        case .dateCreated: return [NSSortDescriptor(key: #keyPath(CDEvent.dateCreated), ascending: true)]
        case .total: return [NSSortDescriptor(key: #keyPath(CDEvent.name), ascending: true)] // TODO: finish this
        case .manual: return [] // TODO: finish this
        } }()

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

    public func hasNoVisitedEvents() -> Bool { do {
        let request = NSFetchRequest<NSNumber>(entityName: EntityName.Event.rawValue)
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "dateVisited != nil")
        let fetchResult = try moc.fetch(request)
        let visitedEventsCount = fetchResult.first?.intValue ?? 0
        return visitedEventsCount == 0
    } catch { return true } }

    public func hasNoHappenings() -> Bool { do {
        let request = NSFetchRequest<NSNumber>(entityName: EntityName.Happening.rawValue)
        request.resultType = .countResultType
        let fetchResult = try moc.fetch(request)
        let happeningsCount = fetchResult.first?.intValue ?? 0
        return happeningsCount == 0
    } catch { return true } }
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
