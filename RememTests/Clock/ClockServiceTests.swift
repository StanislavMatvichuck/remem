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
    var event: Event!
    var sut: ClockService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let event = Event(context: context)

        coreDataStack = stack
        self.event = event
        event.dateCreated = Date.now
        event.name = "Event"
        sut = ClockService(event, stack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        event = nil
        sut = nil
    }

    func testInit() {
        XCTAssertNotNil(coreDataStack)
        XCTAssertNotNil(event)
        XCTAssertNotNil(sut)
    }

    func testFetchWithBoundaries() {
        event.addDefaultHappening(withDate: Date.weekAgo)
        coreDataStack.save(event.managedObjectContext!)
        var dateFrom = Date.now.startOfWeek!
        let dateTo = Date.now.endOfWeek!
        XCTAssertEqual(sut.fetch(from: dateFrom, to: dateTo).count, 0)
        event.addDefaultHappening()
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
