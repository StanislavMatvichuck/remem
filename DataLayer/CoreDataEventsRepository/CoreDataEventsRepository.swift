//
//  CoreDataEventsRepository.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain
import os

let signposter = OSSignposter()
let signpostID = signposter.makeSignpostID()
extension StaticString {
    static let read: StaticString = "read"
    static let readById: StaticString = "readById"
    static let convert: StaticString = "mapper.convert"
    static let update: StaticString = "mapper.update"
}

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
        let state = signposter.beginInterval(.read, id: signpostID)
        defer { signposter.endInterval(.read, state) }

        let request = CDEvent.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let cdEvents = try moc.fetch(request)
        return cdEvents.map { EventCoreDataMapper.convert(cdEvent: $0) }
    } catch {
        fatalError("Unable to fetch events")
    } }

    public func read(byId: String) -> Event {
        let state = signposter.beginInterval(.readById, id: signpostID)
        defer { signposter.endInterval(.readById, state) }

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
