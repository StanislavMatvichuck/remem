//
//  EventsSorting.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

import Foundation

public enum EventsSorter: Int, Codable, Equatable, CaseIterable {
    case name, dateCreated, total, manual
}

public protocol EventsSortingQuerying { func get() -> EventsSorter }
public protocol EventsSortingCommanding { func set(_: EventsSorter) }
public protocol EventsSortingManualQuerying { func get() -> [String] }
public protocol EventsSortingManualCommanding { func set(_: [String]) }
