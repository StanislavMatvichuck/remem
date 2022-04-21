//
//  EntryTests.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 18.04.2022.
//

import CoreData
@testable import Remem
import XCTest

class EntryTests: XCTestCase {
    var coreDataStack: CoreDataStack!

    var moc: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack()
        moc = coreDataStack.createContainer(inMemory: true).viewContext
    }

    override func tearDown() {
        super.tearDown()
        coreDataStack = nil
        moc = nil
    }

    func testCreation() {
        let newEntry = Entry(context: moc)
        newEntry.name = "Name"
        newEntry.dateCreated = Date()

        coreDataStack.save(moc)

        XCTAssertEqual(newEntry.name, "Name")
        XCTAssertEqual(newEntry.points?.count, 0)
        XCTAssertEqual(newEntry.totalAmount, 0)
        XCTAssertEqual(newEntry.dayAverage, 0)
        XCTAssertEqual(newEntry.weekAverage, 0)
        XCTAssertEqual(newEntry.lastWeekTotal, 0)
        XCTAssertEqual(newEntry.thisWeekTotal, 0)
        XCTAssertEqual(newEntry.daysSince, 1)
    }

    func testDaysSince() {
        let entry01 = createEntry(withDaysOffset: 1)
        let entry02 = createEntry(withDaysOffset: 2)
        let entry03 = createEntry(withDaysOffset: 3)

        XCTAssertEqual(entry01.daysSince, 2)
        XCTAssertEqual(entry02.daysSince, 3)
        XCTAssertEqual(entry03.daysSince, 4)
    }

    func testWeeksSince() {
        let entry00 = createEntry(withDaysOffset: 0)
        let entry01 = createEntry(withDaysOffset: 1)
        let entry05 = createEntry(withDaysOffset: 5)
        let entry07 = createEntry(withDaysOffset: 7)
        let entry12 = createEntry(withDaysOffset: 12)
        let entry18 = createEntry(withDaysOffset: 18)
        let entry22 = createEntry(withDaysOffset: 22)

        // TODO: adapt this logic for retarded 1st day of week
        // TODO: cover all cases during single test launch
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 2)
            XCTAssertEqual(entry05.weeksSince, 2)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 3)
            XCTAssertEqual(entry18.weeksSince, 4)
            XCTAssertEqual(entry22.weeksSince, 5)
        case .tuesday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 2)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 3)
            XCTAssertEqual(entry18.weeksSince, 4)
            XCTAssertEqual(entry22.weeksSince, 4)
        case .wednesday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 2)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 3)
            XCTAssertEqual(entry18.weeksSince, 4)
            XCTAssertEqual(entry22.weeksSince, 4)
        case .thursday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 2)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 3)
            XCTAssertEqual(entry18.weeksSince, 4)
            XCTAssertEqual(entry22.weeksSince, 4)
        case .friday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 2)
            XCTAssertEqual(entry07.weeksSince, 3)
            XCTAssertEqual(entry12.weeksSince, 3)
            XCTAssertEqual(entry18.weeksSince, 4)
            XCTAssertEqual(entry22.weeksSince, 4)
        case .saturday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 1)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 2)
            XCTAssertEqual(entry18.weeksSince, 3)
            XCTAssertEqual(entry22.weeksSince, 4)
        case .sunday:
            XCTAssertEqual(entry00.weeksSince, 1)
            XCTAssertEqual(entry01.weeksSince, 1)
            XCTAssertEqual(entry05.weeksSince, 1)
            XCTAssertEqual(entry07.weeksSince, 2)
            XCTAssertEqual(entry12.weeksSince, 2)
            XCTAssertEqual(entry18.weeksSince, 3)
            XCTAssertEqual(entry22.weeksSince, 4)
        }
    }

    func testTotalAmount() {
        let entry01 = createEntry(withDaysOffset: 0)

        XCTAssertEqual(entry01.totalAmount, 0)
        XCTAssertEqual(entry01.points?.count, 0)

        entry01.addDefaultPoint()
        coreDataStack.save(moc)

        XCTAssertEqual(entry01.totalAmount, 1)
        XCTAssertEqual(entry01.points?.count, 1)

        entry01.addDefaultPoint()
        entry01.addDefaultPoint()
        coreDataStack.save(moc)

        XCTAssertEqual(entry01.totalAmount, 3)
        XCTAssertEqual(entry01.points?.count, 3)
    }

    func testDayAverage() {
        let entry01 = createEntry(withDaysOffset: 0)
        let entry03 = createEntry(withDaysOffset: 7)
        let entry02 = createEntry(withDaysOffset: 1)

        XCTAssertEqual(entry01.dayAverage, 0.0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.dayAverage, 1.0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.dayAverage, 2.0)

        entry02.addDefaultPoint()
        XCTAssertEqual(entry02.dayAverage, 0.5)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 1.0)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 1.5)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 2.0)

        entry03.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry03.dayAverage, 1.0 / 8.0)
        entry03.addDefaultPoint(withDate: .beforeYesterday)
        XCTAssertEqual(entry03.dayAverage, 2.0 / 8.0)
        entry03.addDefaultPoint()
        entry03.addDefaultPoint()
        XCTAssertEqual(entry03.dayAverage, 4.0 / 8.0)

        coreDataStack.save(moc)
    }

    func testWeeksTotal() {
        let entry01 = createEntry(withDaysOffset: 0)
        let entry02 = createEntry(withDaysOffset: 7)
        let entry03 = createEntry(withDaysOffset: 7)

        XCTAssertEqual(entry01.thisWeekTotal, 0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.thisWeekTotal, 1)
        entry01.addDefaultPoint()
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.thisWeekTotal, 3)

        for i in 0 ... 6 {
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for retarded 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(entry02.thisWeekTotal, 1)
            XCTAssertEqual(entry02.lastWeekTotal, 6)
            XCTAssertEqual(entry03.thisWeekTotal, 2)
            XCTAssertEqual(entry03.lastWeekTotal, 12)
        case .tuesday:
            XCTAssertEqual(entry02.thisWeekTotal, 2)
            XCTAssertEqual(entry02.lastWeekTotal, 5)
            XCTAssertEqual(entry03.thisWeekTotal, 4)
            XCTAssertEqual(entry03.lastWeekTotal, 10)
        case .wednesday:
            XCTAssertEqual(entry02.thisWeekTotal, 3)
            XCTAssertEqual(entry02.lastWeekTotal, 4)
            XCTAssertEqual(entry03.thisWeekTotal, 6)
            XCTAssertEqual(entry03.lastWeekTotal, 8)
        case .thursday:
            XCTAssertEqual(entry02.thisWeekTotal, 4)
            XCTAssertEqual(entry02.lastWeekTotal, 3)
            XCTAssertEqual(entry03.thisWeekTotal, 8)
            XCTAssertEqual(entry03.lastWeekTotal, 6)
        case .friday:
            XCTAssertEqual(entry02.thisWeekTotal, 5)
            XCTAssertEqual(entry02.lastWeekTotal, 2)
            XCTAssertEqual(entry03.thisWeekTotal, 10)
            XCTAssertEqual(entry03.lastWeekTotal, 4)
        case .saturday:
            XCTAssertEqual(entry02.thisWeekTotal, 6)
            XCTAssertEqual(entry02.lastWeekTotal, 1)
            XCTAssertEqual(entry03.thisWeekTotal, 12)
            XCTAssertEqual(entry03.lastWeekTotal, 2)
        case .sunday:
            XCTAssertEqual(entry02.thisWeekTotal, 7)
            XCTAssertEqual(entry02.lastWeekTotal, 0)
            XCTAssertEqual(entry03.thisWeekTotal, 14)
            XCTAssertEqual(entry03.lastWeekTotal, 0)
        }
    }

    func testWeekAverage() {
        let entry01 = createEntry(withDaysOffset: 7)
        let entry02 = createEntry(withDaysOffset: 7)
        let entry03 = createEntry(withDaysOffset: 14)

        for i in 0 ... 6 {
            entry01.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        for i in 6 ... 12 {
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(entry01.weekAverage, 3.5)
        XCTAssertEqual(entry02.weekAverage, 7)
        XCTAssertEqual(entry03.weekAverage, 7 / 3)
    }
}

// MARK: - Private
extension EntryTests {
    private func createEntry(withDaysOffset offset: Int) -> Entry {
        let entry = Entry(context: moc)
        entry.name = "Entry"
        entry.dateCreated = Date.now.days(ago: offset)
        return entry
    }
}
