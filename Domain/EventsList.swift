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
