//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain

public enum EventCoreDataMapper {
    enum MapperError: Error { case cdEventConvertAsync }

    public static func convert(cdEvent: CDEvent) -> Event {
        guard
            let id = cdEvent.uuid,
            let name = cdEvent.name,
            let happenings = cdEvent.happenings?.array as? [CDHappening],
            let dateCreated = cdEvent.dateCreated
        else {
            fatalError("unable to convert")
        }

        return Event(
            id: id,
            name: name,
            happenings: happenings.map { Happening(dateCreated: $0.dateCreated!) },
            dateCreated: dateCreated,
            dateVisited: cdEvent.dateVisited
        )
    }

    public static func convert(cdEvent: CDEvent) async throws -> Event {
        guard
            let id = cdEvent.uuid,
            let name = cdEvent.name,
            let happenings = cdEvent.happenings?.array as? [CDHappening],
            let dateCreated = cdEvent.dateCreated
        else { throw MapperError.cdEventConvertAsync }

        var mappedHappenings = [Happening]()

        for happening in happenings {
            try Task.checkCancellation()
            mappedHappenings.append(Happening(dateCreated: happening.dateCreated!))
        }

        return Event(
            id: id,
            name: name,
            happenings: mappedHappenings,
            dateCreated: dateCreated,
            dateVisited: cdEvent.dateVisited
        )
    }

    public static func update(cdEvent: CDEvent, event: Event) {
        cdEvent.uuid = event.id
        cdEvent.name = event.name
        cdEvent.dateCreated = event.dateCreated
        cdEvent.dateVisited = event.dateVisited

        guard let context = cdEvent.managedObjectContext else { return }

        //
        // Happenings
        //

        for existingCdHappening in cdEvent.happenings! { context.delete(existingCdHappening as! NSManagedObject) }

        let mappedHappenings = event.happenings.map {
            let new = CDHappening(
                entity: CDHappening.entity(),
                insertInto: context
            )
            new.dateCreated = $0.dateCreated
            new.value = $0.value
            new.event = cdEvent
            return new
        }

        cdEvent.happenings = NSOrderedSet(array: mappedHappenings)
        cdEvent.happeningsCount = Int32(mappedHappenings.count)
    }
}
