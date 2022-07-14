//
//  CountableEventTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 18.04.2022.
//

import CoreData
@testable import Remem
import XCTest

class CountableEventTests: XCTestCase {
    var coreDataStack: CoreDataStack!

    var moc: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        moc = CoreDataStack.createContainer(inMemory: true).viewContext
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        moc = nil
    }

    func testCreation() {
        let newCountableEvent = CountableEvent(context: moc)
        newCountableEvent.name = "Name"
        newCountableEvent.dateCreated = Date()

        coreDataStack.save(moc)

        XCTAssertEqual(newCountableEvent.name, "Name")
        XCTAssertEqual(newCountableEvent.happenings?.count, 0)
        XCTAssertEqual(newCountableEvent.totalAmount, 0)
        XCTAssertEqual(newCountableEvent.dayAverage, 0)
        XCTAssertEqual(newCountableEvent.weekAverage, 0)
        XCTAssertEqual(newCountableEvent.lastWeekTotal, 0)
        XCTAssertEqual(newCountableEvent.thisWeekTotal, 0)
        XCTAssertEqual(newCountableEvent.daysSince, 1)
    }

    func testDaysSince() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 1)
        let countableEvent02 = createCountableEvent(withDaysOffset: 2)
        let countableEvent03 = createCountableEvent(withDaysOffset: 3)

        XCTAssertEqual(countableEvent01.daysSince, 2)
        XCTAssertEqual(countableEvent02.daysSince, 3)
        XCTAssertEqual(countableEvent03.daysSince, 4)
    }

    func testWeeksSince() {
        let countableEvent00 = createCountableEvent(withDaysOffset: 0)
        let countableEvent01 = createCountableEvent(withDaysOffset: 1)
        let countableEvent05 = createCountableEvent(withDaysOffset: 5)
        let countableEvent07 = createCountableEvent(withDaysOffset: 7)
        let countableEvent12 = createCountableEvent(withDaysOffset: 12)
        let countableEvent18 = createCountableEvent(withDaysOffset: 18)
        let countableEvent22 = createCountableEvent(withDaysOffset: 22)

        // TODO: adapt this logic for retarded 1st day of week
        // TODO: cover all cases during single test launch
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 2)
            XCTAssertEqual(countableEvent05.weeksSince, 2)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 3)
            XCTAssertEqual(countableEvent18.weeksSince, 4)
            XCTAssertEqual(countableEvent22.weeksSince, 5)
        case .tuesday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 2)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 3)
            XCTAssertEqual(countableEvent18.weeksSince, 4)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        case .wednesday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 2)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 3)
            XCTAssertEqual(countableEvent18.weeksSince, 4)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        case .thursday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 2)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 3)
            XCTAssertEqual(countableEvent18.weeksSince, 4)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        case .friday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 2)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 3)
            XCTAssertEqual(countableEvent18.weeksSince, 3)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        case .saturday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 1)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 2)
            XCTAssertEqual(countableEvent18.weeksSince, 3)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        case .sunday:
            XCTAssertEqual(countableEvent00.weeksSince, 1)
            XCTAssertEqual(countableEvent01.weeksSince, 1)
            XCTAssertEqual(countableEvent05.weeksSince, 1)
            XCTAssertEqual(countableEvent07.weeksSince, 2)
            XCTAssertEqual(countableEvent12.weeksSince, 2)
            XCTAssertEqual(countableEvent18.weeksSince, 3)
            XCTAssertEqual(countableEvent22.weeksSince, 4)
        }
    }

    func testTotalAmount() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 0)

        XCTAssertEqual(countableEvent01.totalAmount, 0)
        XCTAssertEqual(countableEvent01.happenings?.count, 0)

        countableEvent01.addDefaultCountableEventHappeningDescription()
        coreDataStack.save(moc)

        XCTAssertEqual(countableEvent01.totalAmount, 1)
        XCTAssertEqual(countableEvent01.happenings?.count, 1)

        countableEvent01.addDefaultCountableEventHappeningDescription()
        countableEvent01.addDefaultCountableEventHappeningDescription()
        coreDataStack.save(moc)

        XCTAssertEqual(countableEvent01.totalAmount, 3)
        XCTAssertEqual(countableEvent01.happenings?.count, 3)
    }

    func testDayAverage() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 0)
        let countableEvent03 = createCountableEvent(withDaysOffset: 7)
        let countableEvent02 = createCountableEvent(withDaysOffset: 1)

        XCTAssertEqual(countableEvent01.dayAverage, 0.0)
        countableEvent01.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent01.dayAverage, 1.0)
        countableEvent01.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent01.dayAverage, 2.0)

        countableEvent02.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent02.dayAverage, 0.5)
        countableEvent02.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(countableEvent02.dayAverage, 1.0)
        countableEvent02.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(countableEvent02.dayAverage, 1.5)
        countableEvent02.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(countableEvent02.dayAverage, 2.0)

        countableEvent03.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(countableEvent03.dayAverage, 1.0 / 8.0)
        countableEvent03.addDefaultCountableEventHappeningDescription(withDate: .beforeYesterday)
        XCTAssertEqual(countableEvent03.dayAverage, 2.0 / 8.0)
        countableEvent03.addDefaultCountableEventHappeningDescription()
        countableEvent03.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent03.dayAverage, 4.0 / 8.0)

        coreDataStack.save(moc)
    }

    func testThisWeekTotal() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 0)
        let countableEvent02 = createCountableEvent(withDaysOffset: 7)
        let countableEvent03 = createCountableEvent(withDaysOffset: 7)

        XCTAssertEqual(countableEvent01.thisWeekTotal, 0)
        countableEvent01.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent01.thisWeekTotal, 1)
        countableEvent01.addDefaultCountableEventHappeningDescription()
        countableEvent01.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(countableEvent01.thisWeekTotal, 3)

        for i in 0 ... 6 {
            countableEvent02.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent03.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent03.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for retarded 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 1)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 2)
        case .tuesday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 2)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 4)
        case .wednesday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 3)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 6)
        case .thursday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 4)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 8)
        case .friday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 5)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 10)
        case .saturday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 6)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 12)
        case .sunday:
            XCTAssertEqual(countableEvent02.thisWeekTotal, 7)
            XCTAssertEqual(countableEvent03.thisWeekTotal, 14)
        }
    }

    func testLastWeekTotal() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 0)
        let countableEvent02 = createCountableEvent(withDaysOffset: 7)
        let countableEvent03 = createCountableEvent(withDaysOffset: 7)

        countableEvent01.addDefaultCountableEventHappeningDescription()
        countableEvent01.addDefaultCountableEventHappeningDescription()
        countableEvent01.addDefaultCountableEventHappeningDescription()

        for i in 0 ... 6 {
            countableEvent02.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent03.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent03.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for retarded 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 6)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 12)
        case .tuesday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 5)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 10)
        case .wednesday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 4)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 8)
        case .thursday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 3)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 6)
        case .friday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 2)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 4)
        case .saturday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 1)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 2)
        case .sunday:
            XCTAssertEqual(countableEvent02.lastWeekTotal, 0)
            XCTAssertEqual(countableEvent03.lastWeekTotal, 0)
        }
    }

    func testWeekAverage() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 7)
        let countableEvent02 = createCountableEvent(withDaysOffset: 7)
        let countableEvent03 = createCountableEvent(withDaysOffset: 14)

        for i in 0 ... 6 {
            countableEvent01.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent02.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
            countableEvent02.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
        }

        for i in 6 ... 12 {
            countableEvent03.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(countableEvent01.weekAverage, 3.5)
        XCTAssertEqual(countableEvent02.weekAverage, 7)
        XCTAssertEqual(countableEvent03.weekAverage, 7 / 3)
    }

    func testIsVisitedFlag() {
        let countableEvent01 = createCountableEvent(withDaysOffset: 0)
        XCTAssertNil(countableEvent01.dateVisited)
        countableEvent01.markAsVisited()
        XCTAssertNotNil(countableEvent01.dateVisited, "Must be set by markAsVisited()")
    }
}

// MARK: - Private
extension CountableEventTests {
    private func createCountableEvent(withDaysOffset offset: Int) -> CountableEvent {
        let countableEvent = CountableEvent(context: moc)
        countableEvent.name = "CountableEvent"
        countableEvent.dateCreated = Date.now.days(ago: offset)
        return countableEvent
    }
}
