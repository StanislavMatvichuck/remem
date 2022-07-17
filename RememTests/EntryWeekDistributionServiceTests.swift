//
//  WeekService.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class EventWeekDistributionTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var event: Event!
    var sut: WeekService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let event = Event(context: context)
        event.name = "Event"
        event.dateCreated = Date.now
        stack.save(context)

        coreDataStack = stack
        self.event = event
        sut = WeekService(event)
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

    func testDaysAmount() {
        XCTAssertEqual(sut.daysAmount, 7)

        let weekOldEvent = Event(context: event.managedObjectContext!)
        weekOldEvent.dateCreated = Date.weekAgo
        weekOldEvent.name = "Week old event"
        let sut = WeekService(weekOldEvent)
        XCTAssertEqual(sut.daysAmount, 14)
    }

    func testTodayIndexRow() {
        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(sut.todayIndexRow, 0)
        case .tuesday:
            XCTAssertEqual(sut.todayIndexRow, 1)
        case .wednesday:
            XCTAssertEqual(sut.todayIndexRow, 2)
        case .thursday:
            XCTAssertEqual(sut.todayIndexRow, 3)
        case .friday:
            XCTAssertEqual(sut.todayIndexRow, 4)
        case .saturday:
            XCTAssertEqual(sut.todayIndexRow, 5)
        case .sunday:
            XCTAssertEqual(sut.todayIndexRow, 6)
        }

        let weekOldEvent = Event(context: event.managedObjectContext!)
        weekOldEvent.dateCreated = Date.weekAgo
        weekOldEvent.name = "Week old event"
        let sut = WeekService(weekOldEvent)

        switch Date.now.weekdayNumber {
        case .monday:
            XCTAssertEqual(sut.todayIndexRow, 7)
        case .tuesday:
            XCTAssertEqual(sut.todayIndexRow, 8)
        case .wednesday:
            XCTAssertEqual(sut.todayIndexRow, 9)
        case .thursday:
            XCTAssertEqual(sut.todayIndexRow, 10)
        case .friday:
            XCTAssertEqual(sut.todayIndexRow, 11)
        case .saturday:
            XCTAssertEqual(sut.todayIndexRow, 12)
        case .sunday:
            XCTAssertEqual(sut.todayIndexRow, 13)
        }
    }

    func testDayOfMonthForIndex() {
        let todayIndexPath = IndexPath(row: sut.todayIndexRow, section: 0)
        let todayDayOfMonthFromCalendar = Calendar.current.dateComponents([.day], from: Date.now).day!
        let todayDayOfMonthFromSUT = sut.dayOfMonth(for: todayIndexPath)
        XCTAssertEqual(todayDayOfMonthFromSUT, todayDayOfMonthFromCalendar)

        // Previous day check
        guard
            todayDayOfMonthFromCalendar > 1,
            sut.todayIndexRow != 0,
            let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)
        else { return }

        let yesterdayDayOfMonthFromCalendar = Calendar.current.dateComponents([.day], from: yesterdayDate).day!
        let yesterdayDayIndexPath = IndexPath(row: sut.todayIndexRow - 1, section: 0)
        let yesterdayDayOfMonthFromSUT = sut.dayOfMonth(for: yesterdayDayIndexPath)
        XCTAssertEqual(yesterdayDayOfMonthFromSUT, yesterdayDayOfMonthFromCalendar)

        // Next day check
        guard
            todayDayOfMonthFromCalendar < 28,
            sut.todayIndexRow < sut.daysAmount - 1,
            let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date.now)
        else { return }

        let tomorrowDayOfMonthFromCalendar = Calendar.current.dateComponents([.day], from: tomorrowDate).day!
        let tomorrowDayIndexPath = IndexPath(row: sut.todayIndexRow + 1, section: 0)
        let tomorrowDayOfMonthFromSUT = sut.dayOfMonth(for: tomorrowDayIndexPath)
        XCTAssertEqual(tomorrowDayOfMonthFromSUT, tomorrowDayOfMonthFromCalendar)
    }

    func testHappeningsAmountForIndex() {
        let todayIndexPath = IndexPath(row: sut.todayIndexRow, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 0)
        event.addDefaultHappening()
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 1)
        event.addDefaultHappening()
        event.addDefaultHappening()
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 3)

        // Yesterday check
        guard sut.todayIndexRow > 0 else { return }
        let yesterdayIndexPath = IndexPath(row: sut.todayIndexRow - 1, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 0)
        event.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 1)
        event.addDefaultHappening(withDate: .yesterday)
        event.addDefaultHappening(withDate: .yesterday)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 3)

        // Tomorrow check
        guard sut.todayIndexRow < sut.daysAmount - 1 else { return }
        let tomorrowIndexPath = IndexPath(row: sut.todayIndexRow + 1, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 0)
        event.addDefaultHappening(withDate: Date.now.days(ago: -1))
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 1)
        event.addDefaultHappening(withDate: Date.now.days(ago: -1))
        event.addDefaultHappening(withDate: Date.now.days(ago: -1))
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 3)
    }
}
