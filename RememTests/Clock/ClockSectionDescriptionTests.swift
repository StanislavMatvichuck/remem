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

    func testHasLastHappening_false() {
        XCTAssertEqual(sut.hasFreshHappening, false)
    }

    // MARK: - Behaviour

    func testAddHappening() {
        sut.addHappening()
        sut.addHappening()
        sut.addHappening()
        XCTAssertEqual(sut.happeningsAmount, 3)
    }

    func testSetHasLastHappening() {
        sut.setHasLastHappening()
        XCTAssertEqual(sut.hasFreshHappening, true)
    }
}
