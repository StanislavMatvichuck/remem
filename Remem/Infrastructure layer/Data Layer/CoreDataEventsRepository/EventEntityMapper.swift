//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData

class EventEntityMapper: EntityMapper<Event, CDEvent> {
    override func entityAccessorKey(_ entity: CDEvent) -> String { entity.uuid! }
    override func entityAccessorKey(_ object: Event) -> String { object.id }

    override func convert(_ entity: CDEvent) -> Event? {
        var happenings = [Happening]()

        for cdHappening in entity.happenings! {
            guard let cdHappening = cdHappening as? CDHappening else { continue }
            let happening = Happening(dateCreated: cdHappening.dateCreated!)
            happenings.append(happening)
        }

        return Event(id: entity.uuid!,
                     name: entity.name!,
                     happenings: happenings,
                     dateCreated: entity.dateCreated!,
                     dateVisited: entity.dateVisited)
    }

    override func update(_ entity: CDEvent, by model: Event) {
        entity.uuid = model.id
        entity.name = model.name
        entity.dateCreated = model.dateCreated
        entity.dateVisited = model.dateVisited

        guard let context = entity.managedObjectContext else { return }

        entity.happenings = nil

        var cdHappenings = [CDHappening]()

        for happening in model.happenings {
            let newCdHappening = CDHappening(entity: CDHappening.entity(), insertInto: context)
            newCdHappening.dateCreated = happening.dateCreated
            newCdHappening.value = happening.value
            cdHappenings.append(newCdHappening)
        }

        entity.happenings = NSOrderedSet(array: cdHappenings)
    }
}
