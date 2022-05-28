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

    func testSegmentsAreEmpty() {
        for i in 0 ... sut.daySectionsList.size - 1 { XCTAssertEqual(sut.daySectionsList.section(at: i)?.pointsAmount, 0) }
        for i in 0 ... sut.nightSectionsList.size - 1 { XCTAssertEqual(sut.nightSectionsList.section(at: i)?.pointsAmount, 0) }
    }

    func testFetchWithBoundaries() {
        entry.addDefaultPoint(withDate: Date.weekAgo)
        coreDataStack.save(entry.managedObjectContext!)
        var dateFrom = Date.now.startOfWeek!
        let dateTo = Date.now.endOfWeek!
        XCTAssertEqual(sut.fetch(from: dateFrom, to: dateTo).count, 0)
        entry.addDefaultPoint()
        XCTAssertEqual(sut.fetch(from: dateFrom, to: dateTo).count, 1)
        dateFrom = Date.weekAgo.startOfWeek!
        XCTAssertEqual(sut.fetch(from: dateFrom, to: dateTo).count, 2)
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
}
