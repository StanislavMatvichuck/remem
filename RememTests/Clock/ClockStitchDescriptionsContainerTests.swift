//
//  ClockStitchesContainerTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

@testable import Remem
import XCTest

class ClockSectionDescriptionsListTests: XCTestCase {
    private var sut: ClockSectionDescriptionsList!
    private var stitchesPer24hours = 72 * 2

    override func setUp() {
        super.setUp()
        sut = ClockSectionDescriptionsList(start: .makeStartOfDay(), end: .makeMidday(), stitchesPer24h: stitchesPer24hours)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testSize() {
        XCTAssertEqual(sut.size, stitchesPer24hours / 2)
    }

    func testAddPoint_firstStitch() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 1))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 1)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
    }

    func testAddPoint_secondStitch() {
        let date = makeTodayDate(withTime: (h: 0, m: 11, s: 1))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 1)
    }

    func testAddPoint_thirdStitch() {
        let date = makeTodayDate(withTime: (h: 0, m: 21, s: 0))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 2)?.pointsAmount, 1)
    }

    func testAddPoint_lastStitch() {
        let date = makeTodayDate(withTime: (h: 11, m: 59, s: 0))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 2)?.pointsAmount, 0)

        XCTAssertEqual(sut.description(at: sut.size - 1)?.pointsAmount, 1)
        XCTAssertEqual(sut.description(at: sut.size - 2)?.pointsAmount, 0)
    }

    func testAddPoint_beforeLastStitch() {
        let date = makeTodayDate(withTime: (h: 11, m: 49, s: 0))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 2)?.pointsAmount, 0)

        XCTAssertEqual(sut.description(at: sut.size - 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: sut.size - 2)?.pointsAmount, 1)
    }

    func testAddPoint_notInRange() {
        let date = makeTodayDate(withTime: (h: 13, m: 0, s: 0))

        sut.addPoint(with: date)

        for i in 0 ... sut.size - 1 {
            XCTAssertEqual(sut.description(at: i)?.pointsAmount, 0)
        }
    }

    func testAddPoint_dayRange() {
        sut = ClockSectionDescriptionsList(start: .makeMidday(), end: .makeEndOfDay(), stitchesPer24h: stitchesPer24hours)

        let date = makeTodayDate(withTime: (h: 12, m: 1, s: 0))

        sut.addPoint(with: date)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 1)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
    }

    func testReset() {
        let firstStitchTime = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let lastStitchTime = makeTodayDate(withTime: (h: 11, m: 59, s: 1))

        sut.addPoint(with: firstStitchTime)
        sut.addPoint(with: lastStitchTime)

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 1)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: sut.size - 1)?.pointsAmount, 1)
        XCTAssertEqual(sut.description(at: sut.size - 2)?.pointsAmount, 0)

        sut.reset()

        XCTAssertEqual(sut.description(at: 0)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: sut.size - 1)?.pointsAmount, 0)
        XCTAssertEqual(sut.description(at: sut.size - 2)?.pointsAmount, 0)
    }

    func testSegmentSizeMiddle() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))

        sut.addPoint(with: date)
        sut.addPoint(with: date2)

        XCTAssertEqual(sut.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.mid)
    }

    func testSegmentSizeBig() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let date3 = makeTodayDate(withTime: (h: 0, m: 0, s: 2))

        sut.addPoint(with: date)
        sut.addPoint(with: date2)
        sut.addPoint(with: date3)

        XCTAssertEqual(sut.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.big)
    }

    func testSegmentMakingWithBigInt() {
        let date = makeTodayDate(withTime: (h: 0, m: 0, s: 0))
        let date2 = makeTodayDate(withTime: (h: 0, m: 0, s: 1))
        let date3 = makeTodayDate(withTime: (h: 0, m: 0, s: 2))
        let date4 = makeTodayDate(withTime: (h: 0, m: 0, s: 3))

        sut.addPoint(with: date)
        sut.addPoint(with: date2)
        sut.addPoint(with: date3)
        sut.addPoint(with: date4)

        XCTAssertEqual(sut.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.big)
    }
}

// MARK: - Private
extension ClockSectionDescriptionsListTests {
    private func makeTodayDate(withTime: (h: Int, m: Int, s: Int)) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)
        components.hour = withTime.h
        components.minute = withTime.m
        components.second = withTime.s
        return calendar.date(from: components)!
    }
}
