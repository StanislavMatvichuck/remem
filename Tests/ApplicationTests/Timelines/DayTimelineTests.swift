//
//  TimelineTests.swift
//  DomainTests
//
//  Created by Stanislav Matvichuck on 01.02.2023.
//

@testable import Application
import Foundation
import Domain
import XCTest

final class DayTimelineTests: XCTestCase, TimelineTesting {
    var sut: DayTimeline<String>!

    override func setUp() {
        super.setUp()
        sut = DayTimeline<String>()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty() {
        XCTAssertEqual(sut.count, 0)
    }

    func test_set_storesString() {
        sut[dateTime] = "Hello"

        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual("Hello", sut[dateTime])
    }

    func test_setAfterHour_replacesValue() {
        sut[dateTime] = value
        sut[anHourLater] = value02

        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(value02, sut[dateTime])
        XCTAssertEqual(value02, sut[anHourLater])
    }

    func test_setAfter12Hours_replacesValue() {
        sut[dateTime] = value
        sut[twelveHoursLater] = value02

        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(value02, sut[dateTime])
        XCTAssertEqual(value02, sut[twelveHoursLater])
    }

    func test_setAfterDay_addsValue() {
        sut[dateTime] = value
        sut[aDayLater] = value02

        XCTAssertEqual(sut.count, 2)
        XCTAssertEqual(value, sut[dateTime])
        XCTAssertEqual(value02, sut[aDayLater])
    }

    func test_setAfterTwoDays_addsTwoValues() {
        sut[dateTime] = value
        sut[twoDaysLater] = value02

        XCTAssertEqual(sut.count, 3)
        XCTAssertEqual(value, sut[dateTime])
        XCTAssertNil(sut[aDayLater])
        XCTAssertEqual(value02, sut[twoDaysLater])
    }

    func test_setAfterAWeek_adds7Values() {
        sut[dateTime] = value
        sut[afterAWeek] = value02

        XCTAssertEqual(sut.count, 8)
        XCTAssertEqual(value, sut[dateTime])
        XCTAssertNil(sut[aDayLater])
        XCTAssertNil(sut[twoDaysLater])
        XCTAssertEqual(value02, sut[afterAWeek])
    }
}
