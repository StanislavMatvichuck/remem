//
//  XCUIElementQueryExtension.swift
//  ApplicationUITests
//
//  Created by Stanislav Matvichuck on 14.03.2024.
//

import XCTest

extension XCUIElementQuery {
    var countForHittables: UInt {
        UInt(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}
