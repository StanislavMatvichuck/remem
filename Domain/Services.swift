//
//  Services.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

public protocol EventsQuerying { func get() -> [Event] }

public protocol EventsCommanding {
    func save(_: Event)
    func delete(_: Event)
}

public protocol GoalsReading {
    func read(forEvent: Event) -> [Goal]
    func read(byId: String) -> Goal?
}

public protocol GoalsWriting {
    func create(goal: Goal)
    func update(id: String, goal: Goal)
    func delete(id: String)
}

public protocol EventsSortingQuerying { func get() -> EventsSorter }
public protocol EventsSortingCommanding { func set(_: EventsSorter) }
public protocol EventsSortingManualQuerying { func get() -> [String] }
public protocol EventsSortingManualCommanding { func set(_: [String]) }
