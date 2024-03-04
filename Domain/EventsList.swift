//
//  EventsRepository.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 14.09.2022.
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
