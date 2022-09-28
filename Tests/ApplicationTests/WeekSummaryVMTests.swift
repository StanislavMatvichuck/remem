//
//  WeekSummaryVMTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.09.2022.
//

import Application
import Domain
import Foundation
import IosUseCases
import XCTest

class WeekSummaryVMTests: XCTestCase {
    var sut: WeekSummaryViewModeling!

    override func setUp() {
        super.setUp()
        let event = Event(name: "Event")
        sut = WeekSummaryViewModel(event: event)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_state_initialTotalIsZero() {
        let total = sut.total(at: .now)

        XCTAssertEqual(total, "0")
    }

    func test_state_initialGoalIsZero() {
        let goal = sut.goalAmount(at: .now)

        XCTAssertEqual(goal, "0")
    }

    func test_hasEventDelegation() {
        XCTAssertTrue(sut is EventEditUseCasingDelegate)
    }
}
