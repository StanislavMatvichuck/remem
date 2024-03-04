//
//  GoalCellViewModelingTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import Foundation

@testable import Application
import Domain
import Foundation
import XCTest

final class GoalCellViewModelingTests: XCTestCase {
    private var sut: (any GoalCellViewModeling)!

    override func setUp() {
        super.setUp()
        sut = GoalViewModel(goal: Goal(
            dateCreated: DayIndex.referenceValue.date,
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date)
        ))
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Tests

    func test_conformsToIdentifiable() { XCTAssertTrue(sut is any Identifiable) }
    func test_conformsToEquatable() { XCTAssertTrue(sut is any Equatable) }
}
