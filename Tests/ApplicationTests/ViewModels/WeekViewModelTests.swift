//
//  WeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekViewModelTests: XCTestCase {
    private var sut: WeekViewModel!

    override func setUp() {
        super.setUp()

        sut = WeekViewModel(
            today: DayComponents.referenceValue,
            event: Event(name: "Event")
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_eventWithHappeningOnFirstDay_addsHappeningToFirstCell() {
        let dateCreated = DayComponents.referenceValue.date
        let event = Event(name: "Event", dateCreated: dateCreated)
        event.addHappening(date: dateCreated.addingTimeInterval(5))

        sut = WeekViewModel(today: DayComponents.referenceValue, event: event)

        XCTAssertEqual(sut.items.first?.happenings.count, 1)
    }

    func test_numberOfDays_dependsOnEventCreationDateAndToday() {
        let event = Event(name: "Event", dateCreated: DayComponents.referenceValue.date)
        let dateTodayMonthAfterCreation = DayComponents.referenceValue.adding(
            components: DateComponents(month: 1)
        )

        let sut = WeekViewModel(today: dateTodayMonthAfterCreation, event: event)

        XCTAssertLessThan(21, sut.items.count)
    }

    func test_numberOfDays_alwaysMultipleOf7() {
        let randomDateOfCreation = DayComponents.referenceValue.adding(
            components: DateComponents(day: Int.random(in: -1000 ..< 1000))
        )
        let randomDateToday = DayComponents.referenceValue.adding(
            components: DateComponents(day: Int.random(in: -1000 ..< 1000))
        )
        let event = Event(name: "Event", dateCreated: randomDateOfCreation.date)
        let sut = WeekViewModel(today: randomDateToday, event: event)

        XCTAssertEqual(sut.items.count % 7, 0)
    }

    func test_numberOfDays_atLeast21() {
        XCTAssertLessThanOrEqual(21, sut.items.count)
    }

    func test_dateCreatedHasWeekdayOffset_firstCellIsMondayBeforeDateCreated() {
        for i in 1 ..< 6 {
            let created = DayComponents.referenceValue.adding(components: DateComponents(day: i))
            let event = Event(name: "Event", dateCreated: created.date)
            let sut = WeekViewModel(today: created, event: event)

            let firstVm = sut.items.first

            XCTAssertEqual(firstVm?.day.europeanWeekDay, WeekDay.monday)
            XCTAssertLessThan(firstVm!.day.date, created.date)
        }
    }

    func test_hasScrollToIndex() {
        let created = DayComponents.referenceValue.adding(components: DateComponents(day: 0))
        let event = Event(name: "Event", dateCreated: created.date)
        let sut = WeekViewModel(today: created, event: event)

        XCTAssertEqual(sut.scrollToIndex, 0)
    }

    func test_scrollToIndex_isAlwaysMonday() {
        /// Random numbers may be replaced with cycle but then it takes significant time to execute
        let createdRandomOffset = Int.random(in: 0 ..< 1000)
        let todayRandomOffset = Int.random(in: 0 ..< 1000)

        let created = DayComponents.referenceValue.adding(components: DateComponents(day: createdRandomOffset))
        let event = Event(name: "Event", dateCreated: created.date)

        let sut = WeekViewModel(today: created.adding(components: DateComponents(day: todayRandomOffset)), event: event)
        let scrollToVm = sut.items[sut.scrollToIndex]

        XCTAssertEqual(scrollToVm.day.europeanWeekDay, WeekDay.monday)
    }
}
