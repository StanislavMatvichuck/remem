//
//  Goal.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Foundation

public struct Goal {
    public let dateCreated: Date
    public let value: Int32

    public init(dateCreated: Date, value: Int32) {
        self.dateCreated = dateCreated
        self.value = value
    }
}
