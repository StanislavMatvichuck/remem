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
        sut = ClockService(entry, stack: coreDataStack)
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
        XCTAssertEqual(sut.daySectionsList.size, Self.segmentsCount)
        XCTAssertEqual(sut.nightSectionsList.size, Self.segmentsCount)
    }

    func testArrayIsEmpty() {
        for i in 0 ... sut.daySectionsList.size - 1 { XCTAssertEqual(sut.daySectionsList.description(at: i)?.pointsAmount, 0) }
        for i in 0 ... sut.nightSectionsList.size - 1 { XCTAssertEqual(sut.nightSectionsList.description(at: i)?.pointsAmount, 0) }
    }

    func testFirstSegment() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0))

        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.little)
    }

    func testSecondSegment() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 11, s: 0))

        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, .empty)
        XCTAssertEqual(sut.nightSectionsList.description(at: 1)?.variant, .little)
    }

    func testThirdSegment() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 21, s: 0))

        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, .empty)
        XCTAssertEqual(sut.nightSectionsList.description(at: 1)?.variant, .empty)
        XCTAssertEqual(sut.nightSectionsList.description(at: 2)?.variant, .little)
    }

    func testLastSegment() {
        arrangeEntryWithPoint(inTime: (h: 23, m: 59, s: 59))

        XCTAssertEqual(sut.daySectionsList.description(at: Self.segmentsCount - 1)?.variant, ClockSectionDescription.VisualVariant.little)
        XCTAssertEqual(sut.daySectionsList.description(at: Self.segmentsCount - 2)?.variant, ClockSectionDescription.VisualVariant.empty)
    }

    func testBeforeLastSegment() {
        arrangeEntryWithPoint(inTime: (h: 23, m: 49, s: 39))

        XCTAssertEqual(sut.daySectionsList.description(at: Self.segmentsCount - 1)?.variant, .empty)
        XCTAssertEqual(sut.daySectionsList.description(at: Self.segmentsCount - 2)?.variant, .little)
        XCTAssertEqual(sut.daySectionsList.description(at: Self.segmentsCount - 3)?.variant, .empty)
    }

    func testSegmentSizeMiddle() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 2)
        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.mid)
    }

    func testSegmentSizeBig() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 3)
        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.big)
    }

    func testSegmentMakingWithBigInt() {
        arrangeEntryWithPoint(inTime: (h: 0, m: 0, s: 0), pointsAmount: 4)
        XCTAssertEqual(sut.nightSectionsList.description(at: 0)?.variant, ClockSectionDescription.VisualVariant.big)
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

    private func arrangeEntryWithPoint(inTime: (h: Int, m: Int, s: Int), pointsAmount: Int = 1) {
        let date = makeTodayDate(withTime: inTime)

        for _ in 1 ... pointsAmount {
            entry.addDefaultPoint(withDate: date)
        }

        coreDataStack.save(entry.managedObjectContext!)

        sut.fetch()
    }
}
