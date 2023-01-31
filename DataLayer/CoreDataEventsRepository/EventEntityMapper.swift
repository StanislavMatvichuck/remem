//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Domain

public class EventEntityMapper: EntityMapper<Event, CDEvent> {
    override public init() { super.init() }

    override public func entityAccessorKey(_ entity: CDEvent) -> String { entity.uuid! }
    override public func entityAccessorKey(_ object: Event) -> String { object.id }

    override public func convert(_ entity: CDEvent) -> Event? {
        let event = Event(
            id: entity.uuid!,
            name: entity.name!,
            happenings: [],
            dateCreated: entity.dateCreated!,
            dateVisited: entity.dateVisited
        )

        for cdHappening in entity.happenings! {
            guard let cdHappening = cdHappening as? CDHappening else { continue }
            event.addHappening(date: cdHappening.dateCreated!)
        }

        return event
    }

    override public func update(_ entity: CDEvent, by model: Event) {
        entity.uuid = model.id
        entity.name = model.name
        entity.dateCreated = model.dateCreated
        entity.dateVisited = model.dateVisited

        guard let context = entity.managedObjectContext else { return }

        //
        // Happenings
        //

        for existingCdHappening in entity.happenings! { context.delete(existingCdHappening as! NSManagedObject) }

        var cdHappenings = [CDHappening]()

        for happening in model.happenings {
            let newCdHappening = CDHappening(
                entity: CDHappening.entity(),
                insertInto: context
            )
            newCdHappening.dateCreated = happening.dateCreated
            newCdHappening.value = happening.value
            newCdHappening.event = entity

            cdHappenings.append(newCdHappening)
        }

        entity.happenings = NSOrderedSet(array: cdHappenings)
    }
}
