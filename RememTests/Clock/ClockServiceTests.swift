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
    var countableEvent: CountableEvent!
    var sut: ClockService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let countableEvent = CountableEvent(context: context)

        coreDataStack = stack
        self.countableEvent = countableEvent
        countableEvent.dateCreated = Date.now
        countableEvent.name = "CountableEvent"
        sut = ClockService(countableEvent, stack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        countableEvent = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(countableEvent)
        XCTAssertNotNil(sut)
    }

    func testFetchWithBoundaries() {
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: Date.weekAgo)
        coreDataStack.save(countableEvent.managedObjectContext!)
        var dateFrom = Date.now.startOfWeek!
        let dateTo = Date.now.endOfWeek!
        XCTAssertEqual(sut.fetch(from: dateFrom, to: dateTo).count, 0)
        countableEvent.addDefaultCountableEventHappeningDescription()
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
