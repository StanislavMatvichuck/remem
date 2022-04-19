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
//        XCTAssertEqual(newEntry.totalAmount, 0)
//        XCTAssertEqual(newEntry.dayAverage, 0)
//        XCTAssertEqual(newEntry.weekAverage, 0)
//        XCTAssertEqual(newEntry.lastWeekTotal, 0)
//        XCTAssertEqual(newEntry.thisWeekTotal, 0)
//        XCTAssertEqual(newEntry.daysSince, 1)
    }

    func testDaysSince() {
        let entry01 = Entry(context: moc)
        entry01.name = "Yesterday"
        entry01.dateCreated = .yesterday

        XCTAssertEqual(entry01.daysSince, 2)

        let entry02 = Entry(context: moc)
        entry02.name = "Before yesterday"
        entry02.dateCreated = .beforeYesterday

        XCTAssertEqual(entry02.daysSince, 3)

        let entry03 = Entry(context: moc)
        entry03.name = "Before yesterday"
        entry03.dateCreated = Date.now.days(ago: 3)

        XCTAssertEqual(entry03.daysSince, 4)
    }

    /// Some of these test may break after time
    ///  Were tested on Tuesday 19 April 2022
    func testWeeksSince() {
        let entry01 = Entry(context: moc)
        entry01.name = "Entry"
        entry01.dateCreated = Date.now.days(ago: 24)
        print("entry01 date created \(entry01.dateCreated!)")
        XCTAssertEqual(entry01.daysSince, 25)
        XCTAssertEqual(entry01.weeksSince, 5)

        let entry02 = Entry(context: moc)
        entry02.name = "Entry"
        entry02.dateCreated = Date.now.days(ago: 21)
        print("entry02 date created \(entry02.dateCreated!)")
        XCTAssertEqual(entry02.daysSince, 22)
        XCTAssertEqual(entry02.weeksSince, 4)

        let entry03 = Entry(context: moc)
        entry03.name = "Entry"
        entry03.dateCreated = Date.now.days(ago: 16)
        print("entry03 date created \(entry03.dateCreated!)")
        XCTAssertEqual(entry03.daysSince, 17)
        XCTAssertEqual(entry03.weeksSince, 4)

        let entry04 = Entry(context: moc)
        entry04.name = "Entry"
        entry04.dateCreated = Date.now.days(ago: 15)
        print("entry04 date created \(entry04.dateCreated!)")
        XCTAssertEqual(entry04.daysSince, 16)
        XCTAssertEqual(entry04.weeksSince, 3)

        let entry05 = Entry(context: moc)
        entry05.name = "Entry"
        entry05.dateCreated = Date.now.days(ago: 14)
        print("entry05 date created \(entry05.dateCreated!)")
        XCTAssertEqual(entry05.daysSince, 15)
        XCTAssertEqual(entry05.weeksSince, 3)

        let entry06 = Entry(context: moc)
        entry06.name = "Entry"
        entry06.dateCreated = Date.now.days(ago: 3)
        print("entry06 date created \(entry06.dateCreated!)")
        XCTAssertEqual(entry06.daysSince, 4)
        XCTAssertEqual(entry06.weeksSince, 2)

        let entry07 = Entry(context: moc)
        entry07.name = "Entry"
        entry07.dateCreated = Date.now.days(ago: 1)
        print("entry07 date created \(entry07.dateCreated!)")
        XCTAssertEqual(entry07.daysSince, 2)
        XCTAssertEqual(entry07.weeksSince, 1)
    }

    func testTotalAmount() {
        let entry01 = Entry(context: moc)
        entry01.name = "Entry"
        entry01.dateCreated = Date()

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
        let entry01 = Entry(context: moc)
        entry01.name = "Day average"
        entry01.dateCreated = Date()

        XCTAssertEqual(entry01.dayAverage, 0.0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.dayAverage, 1.0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.dayAverage, 2.0)

        let entry02 = Entry(context: moc)
        entry02.name = "Two days average"
        entry02.dateCreated = .yesterday

        entry02.addDefaultPoint()
        XCTAssertEqual(entry02.dayAverage, 0.5)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 1.0)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 1.5)
        entry02.addDefaultPoint(withDate: .yesterday)
        XCTAssertEqual(entry02.dayAverage, 2.0)

        let entry03 = Entry(context: moc)
        entry03.name = "Week average"
        entry03.dateCreated = .weekAgo

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
        let entry01 = Entry(context: moc)
        entry01.name = "New entry"
        entry01.dateCreated = Date.now

        XCTAssertEqual(entry01.thisWeekTotal, 0)
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.thisWeekTotal, 1)

        entry01.addDefaultPoint()
        entry01.addDefaultPoint()
        XCTAssertEqual(entry01.thisWeekTotal, 3)

        let entry02 = Entry(context: moc)
        entry02.name = "Week old entry"
        entry02.dateCreated = .weekAgo

        for i in 0 ... 6 {
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for american 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(entry02.thisWeekTotal, 1)
            XCTAssertEqual(entry02.lastWeekTotal, 6)
        case .tuesday:
            XCTAssertEqual(entry02.thisWeekTotal, 2)
            XCTAssertEqual(entry02.lastWeekTotal, 5)
        case .wednesday:
            XCTAssertEqual(entry02.thisWeekTotal, 3)
            XCTAssertEqual(entry02.lastWeekTotal, 4)
        case .thursday:
            XCTAssertEqual(entry02.thisWeekTotal, 4)
            XCTAssertEqual(entry02.lastWeekTotal, 3)
        case .friday:
            XCTAssertEqual(entry02.thisWeekTotal, 5)
            XCTAssertEqual(entry02.lastWeekTotal, 2)
        case .saturday:
            XCTAssertEqual(entry02.thisWeekTotal, 6)
            XCTAssertEqual(entry02.lastWeekTotal, 1)
        case .sunday:
            XCTAssertEqual(entry02.thisWeekTotal, 7)
            XCTAssertEqual(entry02.lastWeekTotal, 0)
        }

        let entry03 = Entry(context: moc)
        entry03.name = "Week old entry"
        entry03.dateCreated = .weekAgo

        for i in 0 ... 6 {
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        // TODO: adapt this logic for american 1st day of week
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(entry03.thisWeekTotal, 2)
            XCTAssertEqual(entry03.lastWeekTotal, 12)
        case .tuesday:
            XCTAssertEqual(entry03.thisWeekTotal, 4)
            XCTAssertEqual(entry03.lastWeekTotal, 10)
        case .wednesday:
            XCTAssertEqual(entry03.thisWeekTotal, 6)
            XCTAssertEqual(entry03.lastWeekTotal, 8)
        case .thursday:
            XCTAssertEqual(entry03.thisWeekTotal, 8)
            XCTAssertEqual(entry03.lastWeekTotal, 6)
        case .friday:
            XCTAssertEqual(entry03.thisWeekTotal, 10)
            XCTAssertEqual(entry03.lastWeekTotal, 4)
        case .saturday:
            XCTAssertEqual(entry03.thisWeekTotal, 12)
            XCTAssertEqual(entry03.lastWeekTotal, 2)
        case .sunday:
            XCTAssertEqual(entry03.thisWeekTotal, 14)
            XCTAssertEqual(entry03.lastWeekTotal, 0)
        }
    }

    func testWeekAverage() {
        let entry01 = Entry(context: moc)
        entry01.name = "Entry"
        entry01.dateCreated = .weekAgo

        for i in 0 ... 6 {
            entry01.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(entry01.weekAverage, 3.5)

        let entry02 = Entry(context: moc)
        entry02.name = "Entry"
        entry02.dateCreated = .weekAgo

        for i in 0 ... 6 {
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
            entry02.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(entry02.weekAverage, 7)

        let entry03 = Entry(context: moc)
        entry03.name = "Entry"
        entry03.dateCreated = Date.now.days(ago: 14)

        for i in 6 ... 12 {
            entry03.addDefaultPoint(withDate: Date.now.days(ago: i))
        }

        XCTAssertEqual(entry03.weekAverage, 7 / 3)
    }
}
