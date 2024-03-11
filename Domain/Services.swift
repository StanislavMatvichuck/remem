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

public protocol Command { func execute() }
public protocol GoalsQuerying { func get(for: Event) -> [Goal] }
public protocol GoalsCommanding {
    func save(_: Goal)
    func remove(_: Goal)
}

public protocol EventsSortingQuerying { func get() -> EventsSorter }
public protocol EventsSortingCommanding { func set(_: EventsSorter) }
public protocol EventsSortingManualQuerying { func get() -> [String] }
public protocol EventsSortingManualCommanding { func set(_: [String]) }
