//
//  DomainEvent.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

enum EventManipulationError: Error {
    case invalidHappeningDeletion
}

class Event {
    typealias Goals = [Goal.WeekDay: [Goal]]
    static let defaultGoals: Goals = [
        Goal.WeekDay.monday: [],
        Goal.WeekDay.tuesday: [],
        Goal.WeekDay.wednesday: [],
        Goal.WeekDay.thursday: [],
        Goal.WeekDay.friday: [],
        Goal.WeekDay.saturday: [],
        Goal.WeekDay.sunday: [],
    ]

    let id: String
    var name: String
    var happenings: [Happening]

    let dateCreated: Date
    var dateVisited: Date?

    private var goals: Goals = Event.defaultGoals

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
         dateVisited: Date?,
         goals: Goals = defaultGoals)
    {
        self.id = id
        self.name = name
        self.happenings = happenings
        self.dateCreated = dateCreated
        self.dateVisited = dateVisited
        self.goals = goals
    }
}

// MARK: - Public
extension Event {
    @discardableResult
    func addHappening(date: Date) -> Happening {
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

    func happenings(forDay: Date) -> [Happening] {
        happenings
            .filter { $0.dateCreated.isInSameDay(as: forDay) }
            .sorted(by: { $0.dateCreated > $1.dateCreated })
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

    func goals(at accessDay: Goal.WeekDay) -> [Goal] {
        goals[accessDay] ?? [Goal]()
    }

    @discardableResult
    func addGoal(at dateCreated: Date, amount: Int) -> Goal {
        let newGoal = Goal(amount: amount,
                           event: self,
                           dateCreated: dateCreated)

        var mutableGoalsArray = goals[Goal.WeekDay.make(dateCreated)]

        mutableGoalsArray?.append(newGoal)

        goals[Goal.WeekDay.make(dateCreated)] = mutableGoalsArray

        return newGoal
    }
}

// MARK: - Equatable
extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.dateVisited == rhs.dateVisited &&
            lhs.happenings == rhs.happenings
    }
}
