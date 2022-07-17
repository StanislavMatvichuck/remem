//
//  EventTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 18.04.2022.
//

import CoreData
@testable import Remem
import XCTest

class EventTests: XCTestCase {
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
        let newEvent = Event(context: moc)
        newEvent.name = "Name"
        newEvent.dateCreated = Date()

        coreDataStack.save(moc)

        XCTAssertEqual(newEvent.name, "Name")
        XCTAssertEqual(newEvent.happenings?.count, 0)
        XCTAssertEqual(newEvent.totalAmount, 0)
        XCTAssertEqual(newEvent.dayAverage, 0)
        XCTAssertEqual(newEvent.weekAverage, 0)
        XCTAssertEqual(newEvent.lastWeekTotal, 0)
        XCTAssertEqual(newEvent.thisWeekTotal, 0)
        XCTAssertEqual(newEvent.daysSince, 1)
    }

    func testDaysSince() {
        let event01 = createEvent(withDaysOffset: 1)
        let event02 = createEvent(withDaysOffset: 2)
        let event03 = createEvent(withDaysOffset: 3)

        XCTAssertEqual(event01.daysSince, 2)
        XCTAssertEqual(event02.daysSince, 3)
        XCTAssertEqual(event03.daysSince, 4)
    }

    func testWeeksSince() {
        let event00 = createEvent(withDaysOffset: 0)
        let event01 = createEvent(withDaysOffset: 1)
        let event05 = createEvent(withDaysOffset: 5)
        let event07 = createEvent(withDaysOffset: 7)
        let event12 = createEvent(withDaysOffset: 12)
        let event18 = createEvent(withDaysOffset: 18)
        let event22 = createEvent(withDaysOffset: 22)

        // TODO: adapt this logic for retarded 1st day of week
        // TODO: cover all cases during single test launch
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 2)
            XCTAssertEqual(event05.weeksSince, 2)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 3)
            XCTAssertEqual(event18.weeksSince, 4)
            XCTAssertEqual(event22.weeksSince, 5)
        case .tuesday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 2)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 3)
            XCTAssertEqual(event18.weeksSince, 4)
            XCTAssertEqual(event22.weeksSince, 4)
        case .wednesday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 2)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 3)
            XCTAssertEqual(event18.weeksSince, 4)
            XCTAssertEqual(event22.weeksSince, 4)
        case .thursday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 2)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 3)
            XCTAssertEqual(event18.weeksSince, 4)
            XCTAssertEqual(event22.weeksSince, 4)
        case .friday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 2)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 3)
            XCTAssertEqual(event18.weeksSince, 3)
            XCTAssertEqual(event22.weeksSince, 4)
        case .saturday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 1)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 2)
            XCTAssertEqual(event18.weeksSince, 3)
            XCTAssertEqual(event22.weeksSince, 4)
        case .sunday:
            XCTAssertEqual(event00.weeksSince, 1)
            XCTAssertEqual(event01.weeksSince, 1)
            XCTAssertEqual(event05.weeksSince, 1)
            XCTAssertEqual(event07.weeksSince, 2)
            XCTAssertEqual(event12.weeksSince, 2)
            XCTAssertEqual(event18.weeksSince, 3)
            XCTAssertEqual(event22.weeksSince, 4)
        }
    }

    func testTotalAmount() {
        let event01 = createEvent(withDaysOffset: 0)

        XCTAssertEqual(event01.totalAmount, 0)
        XCTAssertEqual(event01.happenings?.count, 0)

        event01.addDefaultHappening()
        coreDataStack.save(moc)

        XCTAssertEqual(event01.totalAmount, 1)
        XCTAssertEqual(event01.happenings?.count, 1)

        event01.addDefaultHappening()
        event01.addDefaultHappening()
        coreDataStack.save(moc)

        XCTAssertEqual(event01.totalAmount, 3)
        XCTAssertEqual(event01.happenings?.count, 3)
    }

    func testDayAverage() {
        let event01 = createEvent(withDaysOffset: 0)
        let event03 = createEvent(withDaysOffset: 7)
        let event02 = createEvent(withDaysOffset: 1)

        XCTAssertEqual(event01.dayAverage, 0.0)
        event01.addDefaultHappening()
        XCTAssertEqual(event01.dayAverage, 1.0)
        event01.addDefaultHappening()
        XCTAssertEqual(event01.dayAverage, 2.0)

        event02.addDefaultHappening()
        XCTAssertEqual(event02.dayAverage, 0.5)
        event02.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(event02.dayAverage, 1.0)
        event02.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(event02.dayAverage, 1.5)
        event02.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(event02.dayAverage, 2.0)

        event03.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(event03.dayAverage, 1.0 / 8.0)
        event03.addDefaultHappening(withDate: .beforeYesterday)
        XCTAssertEqual(event03.dayAverage, 2.0 / 8.0)
        event03.addDefaultHappening()
        event03.addDefaultHappening()
        XCTAssertEqual(event03.dayAverage, 4.0 / 8.0)

        coreDataStack.save(moc)
    }

    func testThisWeekTotal() {
        let event01 = createEvent(withDaysOffset: 0)
        let event02 = createEvent(withDaysOffset: 7)
        let event03 = createEvent(withDaysOffset: 7)

        XCTAssertEqual(event01.thisWeekTotal, 0)
        event01.addDefaultHappening()
        XCTAssertEqual(event01.thisWeekTotal, 1)
        event01.addDefaultHappening()
        event01.addDefaultHappening()
        XCTAssertEqual(event01.thisWeekTotal, 3)

        for i in 0 ... 6 {
            event02.addDefaultHappening(withDate: Date.now.days(ago: i))
            event03.addDefaultHappening(withDate: Date.now.days(ago: i))
            event03.addDefaultHappening(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for retarded 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(event02.thisWeekTotal, 1)
            XCTAssertEqual(event03.thisWeekTotal, 2)
        case .tuesday:
            XCTAssertEqual(event02.thisWeekTotal, 2)
            XCTAssertEqual(event03.thisWeekTotal, 4)
        case .wednesday:
            XCTAssertEqual(event02.thisWeekTotal, 3)
            XCTAssertEqual(event03.thisWeekTotal, 6)
        case .thursday:
            XCTAssertEqual(event02.thisWeekTotal, 4)
            XCTAssertEqual(event03.thisWeekTotal, 8)
        case .friday:
            XCTAssertEqual(event02.thisWeekTotal, 5)
            XCTAssertEqual(event03.thisWeekTotal, 10)
        case .saturday:
            XCTAssertEqual(event02.thisWeekTotal, 6)
            XCTAssertEqual(event03.thisWeekTotal, 12)
        case .sunday:
            XCTAssertEqual(event02.thisWeekTotal, 7)
            XCTAssertEqual(event03.thisWeekTotal, 14)
        }
    }

    func testLastWeekTotal() {
        let event01 = createEvent(withDaysOffset: 0)
        let event02 = createEvent(withDaysOffset: 7)
        let event03 = createEvent(withDaysOffset: 7)

        event01.addDefaultHappening()
        event01.addDefaultHappening()
        event01.addDefaultHappening()

        for i in 0 ... 6 {
            event02.addDefaultHappening(withDate: Date.now.days(ago: i))
            event03.addDefaultHappening(withDate: Date.now.days(ago: i))
            event03.addDefaultHappening(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for retarded 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(event02.lastWeekTotal, 6)
            XCTAssertEqual(event03.lastWeekTotal, 12)
        case .tuesday:
            XCTAssertEqual(event02.lastWeekTotal, 5)
            XCTAssertEqual(event03.lastWeekTotal, 10)
        case .wednesday:
            XCTAssertEqual(event02.lastWeekTotal, 4)
            XCTAssertEqual(event03.lastWeekTotal, 8)
        case .thursday:
            XCTAssertEqual(event02.lastWeekTotal, 3)
            XCTAssertEqual(event03.lastWeekTotal, 6)
        case .friday:
            XCTAssertEqual(event02.lastWeekTotal, 2)
            XCTAssertEqual(event03.lastWeekTotal, 4)
        case .saturday:
            XCTAssertEqual(event02.lastWeekTotal, 1)
            XCTAssertEqual(event03.lastWeekTotal, 2)
        case .sunday:
            XCTAssertEqual(event02.lastWeekTotal, 0)
            XCTAssertEqual(event03.lastWeekTotal, 0)
        }
    }

    func testWeekAverage() {
        let event01 = createEvent(withDaysOffset: 7)
        let event02 = createEvent(withDaysOffset: 7)
        let event03 = createEvent(withDaysOffset: 14)

        for i in 0 ... 6 {
            event01.addDefaultHappening(withDate: Date.now.days(ago: i))
            event02.addDefaultHappening(withDate: Date.now.days(ago: i))
            event02.addDefaultHappening(withDate: Date.now.days(ago: i))
        }

        for i in 6 ... 12 {
            event03.addDefaultHappening(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(event01.weekAverage, 3.5)
        XCTAssertEqual(event02.weekAverage, 7)
        XCTAssertEqual(event03.weekAverage, 7 / 3)
    }

    func testIsVisitedFlag() {
        let event01 = createEvent(withDaysOffset: 0)
        XCTAssertNil(event01.dateVisited)
        event01.markAsVisited()
        XCTAssertNotNil(event01.dateVisited, "Must be set by markAsVisited()")
    }
}

// MARK: - Private
extension EventTests {
    private func createEvent(withDaysOffset offset: Int) -> Event {
        let event = Event(context: moc)
        event.name = "Event"
        event.dateCreated = Date.now.days(ago: offset)
        return event
    }
}
