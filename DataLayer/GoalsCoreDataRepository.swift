//
//  GoalsCoreDataRepository.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import CoreData
import Domain

public struct GoalsCoreDataRepository {
    private let container: NSPersistentContainer
    private var moc: NSManagedObjectContext { container.viewContext }
    public init(container: NSPersistentContainer) { self.container = container }
}

extension GoalsCoreDataRepository: GoalsReading {
    enum EntityName: String { case Goal }
    public func readActiveGoal(forEvent event: Event) -> Goal? {
        let goalsSortedByValue: [Domain.Goal] = { do {
            let request = CDGoal.fetchRequest()
            request.predicate = NSPredicate(format: "event.uuid == %@", event.id)
            request.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
            return try moc.fetch(request).map { GoalCoreDataMapper.make(for: event, cdGoal: $0) }
        } catch { return [] }
        }()

        var activeGoal: Goal?

        for goal in goalsSortedByValue {
            if goal.achieved == false { activeGoal = goal; break }
        }

        if activeGoal == nil { activeGoal = goalsSortedByValue.last }

        return activeGoal
    }

    public func read(forEvent event: Event) -> [Domain.Goal] {
        do {
            let request = CDGoal.fetchRequest()
            request.predicate = NSPredicate(format: "event.uuid == %@", event.id)
            let cdGoals = try moc.fetch(request)
            return cdGoals.map { GoalCoreDataMapper.make(for: event, cdGoal: $0) }
        } catch { fatalError(error.localizedDescription) }
    }

    public func read(byId: String) -> Goal? {
        if let cdGoal = cdGoal(id: byId),
           let cdEvent = cdEvent(id: cdGoal.event!.uuid!)
        {
            return GoalCoreDataMapper.make(for: EventCoreDataMapper.convert(cdEvent: cdEvent), cdGoal: cdGoal)
        }

        return nil
    }

    public func hasGoals(eventId: String) -> Bool { do {
        let request = NSFetchRequest<NSNumber>(entityName: EntityName.Goal.rawValue)
        request.resultType = .countResultType
        request.predicate = NSPredicate(format: "event.uuid == %@", eventId)
        let fetchResult = try moc.fetch(request)
        let goalsCount = fetchResult.first?.intValue ?? 0
        return goalsCount != 0
    } catch { return true } }
}

extension GoalsCoreDataRepository: GoalsWriting {
    public func create(goal: Domain.Goal) {
        guard let cdEvent = cdEvent(id: goal.event.id) else {
            fatalError("Goal cannot be created without cdEvent being in context")
        }

        let cdGoal = CDGoal(entity: CDGoal.entity(), insertInto: moc)
        GoalCoreDataMapper.update(cdGoal: cdGoal, with: goal, cdEvent: cdEvent)
        applyChanges()
    }

    public func update(id: String, goal: Domain.Goal) {
        guard let cdEvent = cdEvent(id: goal.event.id),
              let cdGoal = cdGoal(id: id)
        else {
            fatalError("Trying to update Goal which is not in context")
        }

        GoalCoreDataMapper.update(cdGoal: cdGoal, with: goal, cdEvent: cdEvent)
        applyChanges()
    }

    public func delete(id: String) {
        guard let cdGoal = cdGoal(id: id) else {
            fatalError("Trying to delete a Goal which is not found in context")
        }

        moc.delete(cdGoal)
        applyChanges()
    }
}

extension GoalsCoreDataRepository {
    private func applyChanges() {
        do {
            if moc.hasChanges {
                moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try moc.save()
                print("GoalsCoreDataRepository changes applied")
            } else {
                print("no changes to save in GoalsCoreDataRepository")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func cdEvent(id: String) -> CDEvent? { objectInContext(id: id) }
    private func cdGoal(id: String) -> CDGoal? { objectInContext(id: id) }
    private func objectInContext<T: NSManagedObject>(id: String) -> T? { do {
        let request = T.fetchRequest()
        request.predicate = NSPredicate(format: "uuid == %@", id)
        return try moc.fetch(request).first as? T
    } catch { return nil } }
}
