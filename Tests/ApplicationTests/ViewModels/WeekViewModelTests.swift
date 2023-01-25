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
    private var event: Event!

    override func setUp() {
        super.setUp()
        let today = DayComponents.referenceValue
        let created = DayComponents.referenceValue
        event = Event(name: "Event", dateCreated: created.date)
        sut = make(today: today, created: created, event: event)
    }

    override func tearDown() {
        sut = nil
        event = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_eventWithHappeningOnFirstDay_addsHappeningToFirstCell() {
        event.addHappening(date: DayComponents.referenceValue.date.addingTimeInterval(5))
        sut = make(
            today: DayComponents.referenceValue,
            created: DayComponents.referenceValue,
            event: event
        )

        XCTAssertEqual(sut.items.first?.items.count, 1)
    }

    func test_todayAfterCreation_numberOfDays_moreThan21() {
        let dateTodayMonthAfterCreation = DayComponents.referenceValue.adding(
            components: DateComponents(month: 1)
        )

        sut = make(
            today: dateTodayMonthAfterCreation,
            created: DayComponents.referenceValue,
            event: event
        )

        XCTAssertLessThan(21, sut.items.count)
    }

    func test_sameDates_numberOfDays_21() {
        XCTAssertLessThanOrEqual(21, sut.items.count)
    }

    func test_sameDates_scrollToIndex_0() {
        XCTAssertEqual(sut.scrollToIndex, 0)
    }

    func test_dateCreatedHasWeekdayOffset_firstCellIsMondayBeforeDateCreated() {
        for i in 1 ..< 6 {
            let created = DayComponents.referenceValue.adding(components: DateComponents(day: i))
            let sut = make(
                today: created,
                created: created,
                event: event
            )

            let firstItemDayNumber = Int(sut.items.first!.dayNumber) ?? 0

            XCTAssertEqual(firstItemDayNumber, 1)
            XCTAssertLessThan(firstItemDayNumber, created.europeanWeekDay.rawValue)
        }
    }

    func test_randomDates_scrollToIndex_isAlwaysMonday() {
        arrangeRandomDates()

        let date = sut.items[sut.scrollToIndex].date
        XCTAssertEqual(WeekDay.make(date), WeekDay.monday)
    }

    func test_randomDates_numberOfDays_multipleOf7() {
        arrangeRandomDates()

        XCTAssertEqual(sut.items.count % 7, 0)
    }

    private func make(
        today: DayComponents,
        created: DayComponents,
        event: Event
    ) -> WeekViewModel {
        return ApplicationContainer(testingInMemoryMode: true)
            .makeContainer()
            .makeContainer(event: event, today: today)
            .makeViewModel()
    }

    private func arrangeRandomDates() {
        let randomDateToday = DayComponents.referenceValue.adding(
            components: DateComponents(day: Int.random(in: -1000 ..< 1000))
        )
        let randomDateOfCreation = DayComponents.referenceValue.adding(
            components: DateComponents(day: Int.random(in: -1000 ..< 1000))
        )

        sut = make(today: randomDateToday, created: randomDateOfCreation, event: event)
    }
}
