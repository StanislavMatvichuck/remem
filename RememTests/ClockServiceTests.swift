//
//  ClockServiceTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 16.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class ClockServiceTests: XCTestCase {
    static let segmentsCount = 72

    var coreDataStack: CoreDataStack!
    var entry: Entry!
    var sut: ClockService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let entry = Entry(context: context)

        coreDataStack = stack
        self.entry = entry
        entry.dateCreated = Date.now
        entry.name = "Entry"
        sut = ClockService(entry, stack: coreDataStack, segmentsCount: Self.segmentsCount)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        entry = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(entry)
        XCTAssertNotNil(sut)
    }

    func testSegmentsCount() {
        XCTAssertEqual(sut.fetch().day.count, Self.segmentsCount)
        XCTAssertEqual(sut.fetch().night.count, Self.segmentsCount)
    }

    func testArrayIsEmpty() {
        let result = sut.fetch()

        for element in result.day { XCTAssertEqual(element, .empty) }
        for element in result.night { XCTAssertEqual(element, .empty) }
    }

    func testFirstSegment() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0))

        XCTAssertEqual(stitches.night[0], Clock.StitchVariant.little)
    }

    func testSecondSegment() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 11, s: 0))

        XCTAssertEqual(stitches.night[0], .empty)
        XCTAssertEqual(stitches.night[1], .little)
    }

    func testThirdSegment() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 21, s: 0))

        XCTAssertEqual(stitches.night[0], .empty)
        XCTAssertEqual(stitches.night[1], .empty)
        XCTAssertEqual(stitches.night[2], .little)
    }

    func testLastSegment() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 23, m: 59, s: 59))

        XCTAssertEqual(stitches.day[Self.segmentsCount - 1], .little)
        XCTAssertEqual(stitches.day[Self.segmentsCount - 2], .empty)
    }

    func testBeforeLastSegment() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 23, m: 49, s: 39))

        XCTAssertEqual(stitches.day[Self.segmentsCount - 1], .empty)
        XCTAssertEqual(stitches.day[Self.segmentsCount - 2], .little)
        XCTAssertEqual(stitches.day[Self.segmentsCount - 3], .empty)
    }

    func testSegmentSizeMiddle() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 2)
        XCTAssertEqual(stitches.night.first, .mid)
    }

    func testSegmentSizeBig() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 3)
        XCTAssertEqual(stitches.night.first, .big)
    }

    func testSegmentMakingWithBigInt() {
        let stitches = arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 4)
        XCTAssertEqual(stitches.night.first, .big)
    }
}

// MARK: - Private
extension ClockServiceTests {
    private func makeTodayDate(withTime: (h: Int, m: Int, s: Int)) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date.now)
        components.hour = withTime.h
        components.minute = withTime.m
        components.second = withTime.s
        return calendar.date(from: components)!
    }

    private func arrangeEntryWithPoint(inTime: (h: Int, m: Int, s: Int), pointsAmount: Int = 1) -> ClockService.ClockStitches {
        let date = makeTodayDate(withTime: inTime)
        for _ in 1 ... pointsAmount {
            entry.addDefaultPoint(withDate: date)
        }

        coreDataStack.save(entry.managedObjectContext!)

        return sut.fetch()
    }
}
