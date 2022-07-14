//
//  WeekService.swift
//  RememTests
//
//  Created by Stanislav Matvichuck on 04.05.2022.
//

import CoreData
@testable import Remem
import XCTest

class CountableEventWeekDistributionTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var countableEvent: CountableEvent!
    var sut: WeekService!

    override func setUp() {
        super.setUp()
        let stack = CoreDataStack()
        let container = CoreDataStack.createContainer(inMemory: true)
        let context = container.viewContext
        let countableEvent = CountableEvent(context: context)
        countableEvent.name = "CountableEvent"
        countableEvent.dateCreated = Date.now
        stack.save(context)

        coreDataStack = stack
        self.countableEvent = countableEvent
        sut = WeekService(countableEvent)
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

    func testDaysAmount() {
        XCTAssertEqual(sut.daysAmount, 7)

        let weekOldCountableEvent = CountableEvent(context: countableEvent.managedObjectContext!)
        weekOldCountableEvent.dateCreated = Date.weekAgo
        weekOldCountableEvent.name = "Week old countableEvent"
        let sut = WeekService(weekOldCountableEvent)
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

        let weekOldCountableEvent = CountableEvent(context: countableEvent.managedObjectContext!)
        weekOldCountableEvent.dateCreated = Date.weekAgo
        weekOldCountableEvent.name = "Week old countableEvent"
        let sut = WeekService(weekOldCountableEvent)

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

    func testCountableEventHappeningDescriptionsAmountForIndex() {
        let todayIndexPath = IndexPath(row: sut.todayIndexRow, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 0)
        countableEvent.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 1)
        countableEvent.addDefaultCountableEventHappeningDescription()
        countableEvent.addDefaultCountableEventHappeningDescription()
        XCTAssertEqual(sut.happeningsAmount(for: todayIndexPath), 3)

        // Yesterday check
        guard sut.todayIndexRow > 0 else { return }
        let yesterdayIndexPath = IndexPath(row: sut.todayIndexRow - 1, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 0)
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 1)
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: .yesterday)
        XCTAssertEqual(sut.happeningsAmount(for: yesterdayIndexPath), 3)

        // Tomorrow check
        guard sut.todayIndexRow < sut.daysAmount - 1 else { return }
        let tomorrowIndexPath = IndexPath(row: sut.todayIndexRow + 1, section: 0)
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 0)
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: -1))
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 1)
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: -1))
        countableEvent.addDefaultCountableEventHappeningDescription(withDate: Date.now.days(ago: -1))
        XCTAssertEqual(sut.happeningsAmount(for: tomorrowIndexPath), 3)
    }
}
