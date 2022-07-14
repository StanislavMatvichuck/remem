//
//  ClockSectionTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

@testable import Remem
import XCTest

class ClockSectionTests: XCTestCase {
    private var sut: ClockSection!

    override func setUp() {
        super.setUp()
        sut = ClockSection()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    // MARK: - Initial state

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testAmount_empty() {
        XCTAssertEqual(sut.happeningsAmount, 0)
    }

    func testHasLastCountableEventHappeningDescription_false() {
        XCTAssertEqual(sut.hasFreshCountableEventHappeningDescription, false)
    }

    // MARK: - Behaviour

    func testAddCountableEventHappeningDescription() {
        sut.addCountableEventHappeningDescription()
        sut.addCountableEventHappeningDescription()
        sut.addCountableEventHappeningDescription()
        XCTAssertEqual(sut.happeningsAmount, 3)
    }

    func testSetHasLastCountableEventHappeningDescription() {
        sut.setHasLastCountableEventHappeningDescription()
        XCTAssertEqual(sut.hasFreshCountableEventHappeningDescription, true)
    }
}
