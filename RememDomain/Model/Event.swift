//
//  RememDomain.swift
//  RememDomain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

import Foundation

public enum EventManipulationError: Error {
    case invalidHappeningDeletion
}

public class Event {
    public typealias Goals = [Goal.WeekDay: [Goal]]
    public static let defaultGoals: Goals = [
        Goal.WeekDay.monday: [],
        Goal.WeekDay.tuesday: [],
        Goal.WeekDay.wednesday: [],
        Goal.WeekDay.thursday: [],
        Goal.WeekDay.friday: [],
        Goal.WeekDay.saturday: [],
        Goal.WeekDay.sunday: [],
    ]

    public let id: String
    public var name: String
    public var happenings: [Happening]

    public let dateCreated: Date
    public var dateVisited: Date?

    private var goals: Goals = Event.defaultGoals

    // MARK: - Init
    public
    convenience
    init(name: String) {
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

    public
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
public extension Event {
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

    @discardableResult

    func remove(happening: Happening) throws -> Happening? {
        var happeningDeleted: Happening?

        for (index, existingHappening) in happenings.enumerated() {
            if existingHappening == happening {
                happeningDeleted = happenings.remove(at: index)
                break
            }
        }

        if happeningDeleted == nil { throw EventManipulationError.invalidHappeningDeletion }

        return happeningDeleted
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

        if let goals = goals[accessorDay],
           let endOfDayDate = date.endOfDay
        {
            for goal in goals {
                if endOfDayDate >= goal.dateCreated { resultingGoal = goal }
            }
        }

        return resultingGoal
    }

    func goals(at accessDay: Goal.WeekDay) -> [Goal] {
        goals[accessDay] ?? [Goal]()
    }

    @discardableResult

    func addGoal(at dateCreated: Date, amount: Int) -> Goal {
        let accessWeekday = Goal.WeekDay.make(dateCreated)

        if let existingGoal = goals[accessWeekday]?.last,
           existingGoal.amount == amount
        {
            return existingGoal
        }

        let newGoal = Goal(amount: amount, event: self, dateCreated: dateCreated)

        var mutableGoalsArray = goals[accessWeekday]
        mutableGoalsArray?.append(newGoal)
        goals[accessWeekday] = mutableGoalsArray

        return newGoal
    }
}

// MARK: - Equatable
extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.dateVisited == rhs.dateVisited &&
            lhs.happenings == rhs.happenings
    }
}
