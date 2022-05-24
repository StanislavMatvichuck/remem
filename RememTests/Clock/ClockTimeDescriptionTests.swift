//
//  ClockTimeDescription.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

@testable import Remem
import XCTest

class ClockTimeDescriptionTests: XCTestCase {
    private var sut: ClockTimeDescription!

    override func setUp() {
        super.setUp()
        sut = ClockTimeDescription(hour: 0, minute: 0, second: 0)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testSeconds_zero() {
        XCTAssertEqual(sut.seconds, 0)
    }

    func testSeconds_hour() {
        sut = ClockTimeDescription(hour: 1, minute: 0, second: 0)
        XCTAssertEqual(sut.seconds, 3600)
    }

    func testSeconds_minute() {
        sut = ClockTimeDescription(hour: 0, minute: 1, second: 0)
        XCTAssertEqual(sut.seconds, 60)
    }

    func testSeconds_sum() {
        sut = ClockTimeDescription(hour: 1, minute: 1, second: 1)
        XCTAssertEqual(sut.seconds, 3661)
    }
}
