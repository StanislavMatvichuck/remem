//
//  EventEntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import CoreData
import RememDomain

class EventEntityMapper: EntityMapper<Event, CDEvent> {
    override func entityAccessorKey(_ entity: CDEvent) -> String { entity.uuid! }
    override func entityAccessorKey(_ object: Event) -> String { object.id }

    override func convert(_ entity: CDEvent) -> Event? {
        //
        // Happenings
        //
        var happenings = [Happening]()

        for cdHappening in entity.happenings! {
            guard let cdHappening = cdHappening as? CDHappening else { continue }
            let happening = Happening(dateCreated: cdHappening.dateCreated!)
            happenings.append(happening)
        }

        let newEvent = Event(id: entity.uuid!,
                             name: entity.name!,
                             happenings: happenings,
                             dateCreated: entity.dateCreated!,
                             dateVisited: entity.dateVisited)

        //
        // Goals
        //

        for cdGoal in entity.goals! {
            guard let goal = cdGoal as? CDGoal else { continue }
            newEvent.addGoal(at: goal.dateCreated!, amount: Int(exactly: goal.value)!)
        }

        return newEvent
    }

    override func update(_ entity: CDEvent, by model: Event) {
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
            let newCdHappening = CDHappening(entity: CDHappening.entity(), insertInto: context)
            newCdHappening.dateCreated = happening.dateCreated
            newCdHappening.value = happening.value
            cdHappenings.append(newCdHappening)
        }

        entity.happenings = NSOrderedSet(array: cdHappenings)

        //
        // Goals
        //

        for existingCdGoal in entity.goals! { context.delete(existingCdGoal as! NSManagedObject) }

        var cdGoals = [CDGoal]()

        for weekday in Goal.WeekDay.allCases {
            for goal in model.goals(at: weekday) {
                let newCdGoal = CDGoal(entity: CDGoal.entity(), insertInto: context)
                newCdGoal.dateCreated = goal.dateCreated
                newCdGoal.value = Int32(goal.amount)
                newCdGoal.event = entity
                cdGoals.append(newCdGoal)
            }
        }

        entity.goals = NSOrderedSet(array: cdGoals)
    }
}
