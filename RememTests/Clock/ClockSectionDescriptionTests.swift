//
//  ClockStitchesDescriptionTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

@testable import Remem
import XCTest

class ClockSectionDescriptionTests: XCTestCase {
    private var sut: ClockSectionDescription!

    override func setUp() {
        super.setUp()
        sut = ClockSectionDescription()
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
        XCTAssertEqual(sut.pointsAmount, 0)
    }

    func testHasLastPoint_false() {
        XCTAssertEqual(sut.hasFreshPoint, false)
    }

    // MARK: - Behaviour

    func testAddPoint() {
        sut.addPoint()
        sut.addPoint()
        sut.addPoint()
        XCTAssertEqual(sut.pointsAmount, 3)
    }

    func testSetHasLastPoint() {
        sut.setHasLastPoint()
        XCTAssertEqual(sut.hasFreshPoint, true)
    }
}
