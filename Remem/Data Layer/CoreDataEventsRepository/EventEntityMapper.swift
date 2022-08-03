//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import Foundation

class EventEntityMapper: EntityMapper<DomainEvent, Event> {
    override func convert(_ entity: Event) -> DomainEvent? {
        var happenings = [DomainHappening]()
        for cdHappening in entity.happenings! {
            guard let cdHappening = cdHappening as? Happening else { continue }
            let happening = DomainHappening(dateCreated: cdHappening.dateCreated!)
            happenings.append(happening)
        }

        let model = DomainEvent(id: entity.dateCreated!.description,
                                name: entity.name!,
                                happenings: happenings,
                                dateCreated: entity.dateCreated!,
                                dateVisited: entity.dateVisited)
        return model
    }

    override func update(_ entity: Event, by model: DomainEvent) {
        entity.name = model.name
        entity.dateCreated = model.dateCreated
        entity.dateVisited = model.dateVisited

        guard let context = entity.managedObjectContext else { return }

        for existingCdHappening in entity.happenings! {
            context.delete(existingCdHappening as! NSManagedObject)
        }

        var cdHappenings = NSSet(set: Set<Happening>())

        for happening in model.happenings {
            let newCdHappening = Happening(entity: Happening.entity(), insertInto: context)
            newCdHappening.dateCreated = happening.dateCreated
            newCdHappening.value = happening.value
            newCdHappening.event = entity
            cdHappenings = cdHappenings.adding(newCdHappening) as NSSet
        }

        entity.happenings = cdHappenings
    }

    override func entityAccessorKey(_ entity: Event) -> String {
        entity.dateCreated!.description
    }

    override func entityAccessorKey(_ object: DomainEvent) -> String {
        object.dateCreated.description
    }
}
