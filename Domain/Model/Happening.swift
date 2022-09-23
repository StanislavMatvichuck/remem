//
//  Happening.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 13.09.2022.
//

import Foundation

public struct Happening: Equatable {
    public let dateCreated: Date
    public var value: Int32

    public init(dateCreated: Date, value: Int32 = 1) {
        self.dateCreated = dateCreated
        self.value = value
    }
}
