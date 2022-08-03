//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Foundation

class EventEntityMapper: EntityMapper<Event, CDEvent> {
    override func convert(_ entity: CDEvent) -> Event? {
        var happenings = [Happening]()
        for cdHappening in entity.happenings! {
            guard let cdHappening = cdHappening as? CDHappening else { continue }
            let happening = Happening(dateCreated: cdHappening.dateCreated!)
            happenings.append(happening)
        }

        let model = Event(id: entity.dateCreated!.description,
                                name: entity.name!,
                                happenings: happenings,
                                dateCreated: entity.dateCreated!,
                                dateVisited: entity.dateVisited)
        return model
    }

    override func update(_ entity: CDEvent, by model: Event) {
        entity.name = model.name
        entity.dateCreated = model.dateCreated
        entity.dateVisited = model.dateVisited

        guard let context = entity.managedObjectContext else { return }

        for existingCdHappening in entity.happenings! {
            context.delete(existingCdHappening as! NSManagedObject)
        }

        var cdHappenings = NSSet(set: Set<CDHappening>())

        for happening in model.happenings {
            let newCdHappening = CDHappening(entity: CDHappening.entity(), insertInto: context)
            newCdHappening.dateCreated = happening.dateCreated
            newCdHappening.value = happening.value
            newCdHappening.event = entity
            cdHappenings = cdHappenings.adding(newCdHappening) as NSSet
        }

        entity.happenings = cdHappenings
    }

    override func entityAccessorKey(_ entity: CDEvent) -> String {
        entity.dateCreated!.description
    }

    override func entityAccessorKey(_ object: Event) -> String {
        object.dateCreated.description
    }
}
