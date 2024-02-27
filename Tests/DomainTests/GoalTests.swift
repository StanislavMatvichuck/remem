//
//  GoalTests.swift
//  DomainTests
//
//  Created by Stanislav Matvichuck on 26.02.2024.
//

import Domain
import Foundation
import XCTest

final class GoalTests: XCTestCase {
    private var sut: Goal!
    
    override func setUp() {
        super.setUp()
        sut = Goal(dateCreated: DayIndex.referenceValue.date, value: 0)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init_requiresDateCreatedAndValue() { XCTAssertNotNil(sut) }
}
