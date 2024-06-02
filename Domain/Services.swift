//
//  Services.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

public protocol EventsReading {
    func read() -> [Event]
    func read(byId: String) -> Event
    func readAsync(byId: String) async throws -> Event
    func identifiers() -> [String]
}

public protocol EventsWriting {
    func create(event: Event)
    func update(id: String, event: Event)
    func delete(id: String)
}

public protocol GoalsReading {
    func read(forEvent: Event) -> [Goal]
    func readActiveGoal(forEvent: Event) -> Goal?
    func read(byId: String) -> Goal?
}

public protocol GoalsWriting {
    func create(goal: Goal)
    func update(id: String, goal: Goal)
    func delete(id: String)
}

public protocol EventsSorterReading { func get() -> EventsSorter }
public protocol EventsSorterWriting { func set(_: EventsSorter) }
public protocol ManualEventsSorterReading { func get() -> [String] }
public protocol ManualEventsSorterWriting { func set(_: [String]) }
