//
//  EventsSorter.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

public enum EventsSorter: Int, Codable, Equatable, CaseIterable {
    case name, dateCreated, total, manual
}
