//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

class Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.dateVisited == rhs.dateVisited &&
            lhs.happenings == rhs.happenings
    }

    let id: String
    var name: String
    var happenings: [Happening]

    let dateCreated: Date
    var dateVisited: Date?

    private var goals: [Goal.WeekDay: [Goal]] = [
        Goal.WeekDay.monday: [],
        Goal.WeekDay.tuesday: [],
        Goal.WeekDay.wednesday: [],
        Goal.WeekDay.thursday: [],
        Goal.WeekDay.friday: [],
        Goal.WeekDay.saturday: [],
        Goal.WeekDay.sunday: [],
    ]

    // MARK: - Init
    convenience init(name: String) {
        let dateCreated: Date = {
            let c = Calendar.current
            let creationDate = Date.now
            var components = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: creationDate)
            components.hour = 0
            components.minute = 0
            components.second = 0

            if let date = c.date(from: components) { return date }
            else { return creationDate }
        }()

        self.init(id: UUID().uuidString,
                  name: name,
                  happenings: [Happening](),
                  dateCreated: dateCreated,
                  dateVisited: nil)
    }

    init(id: String,
         name: String,
         happenings: [Happening],
         dateCreated: Date,
         dateVisited: Date?)
    {
        self.id = id
        self.name = name
        self.happenings = happenings
        self.dateCreated = dateCreated
        self.dateVisited = dateVisited
    }
}

enum EventManipulationError: Error {
    case incorrectHappeningDate
    case invalidHappeningDeletion
}

// MARK: - Public
extension Event {
    @discardableResult
    func addHappening(date: Date) throws -> Happening {
        if date < dateCreated { throw EventManipulationError.incorrectHappeningDate }

        let insertIndex = happenings.firstIndex { happening in
            happening.dateCreated < date
        } ?? 0

        let newHappening = Happening(dateCreated: date)
        happenings.insert(newHappening, at: insertIndex)

        return newHappening
    }

    func visit() {
        dateVisited = Date.now
    }

    func remove(happening: Happening) throws {
        var happeningDeleted = false

        for (index, existingHappening) in happenings.enumerated() {
            if existingHappening == happening {
                happenings.remove(at: index)
                happeningDeleted = true
                break
            }
        }

        if !happeningDeleted { throw EventManipulationError.invalidHappeningDeletion }
    }

    // Goals
    func goal(at date: Date) -> Goal? {
        let accessorDay = Goal.WeekDay.make(date)
        var resultingGoal: Goal?

        if let goals = goals[accessorDay] {
            for goal in goals { if date >= goal.dateCreated { resultingGoal = goal } }
        }

        return resultingGoal
    }

    @discardableResult
    func addGoal(at dateCreated: Date, amount: Int) -> Goal {
        let newGoal = Goal(amount: amount,
                           event: self,
                           dateCreated: dateCreated,
                           dateDisabled: nil)

        var mutableGoalsArray = goals[Goal.WeekDay.make(dateCreated)]

        if let goalsArray = mutableGoalsArray, !goalsArray.isEmpty {
            mutableGoalsArray?[goalsArray.count - 1].dateDisabled = dateCreated
        }

        mutableGoalsArray?.append(newGoal)

        goals[Goal.WeekDay.make(dateCreated)] = mutableGoalsArray

        return newGoal
    }

    func disableGoal(at date: Date) {
        var mutableGoalsArray = goals[Goal.WeekDay.make(date)]

        if let goalsArray = mutableGoalsArray, !goalsArray.isEmpty {
            mutableGoalsArray?[goalsArray.count - 1].dateDisabled = date
        }

        goals[Goal.WeekDay.make(date)] = mutableGoalsArray
    }
}

// MARK: - Private
extension Event {
    private func add(goal: Goal, at date: Date) {}
}
