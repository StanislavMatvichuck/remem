//
//  WeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

final class WeekViewModelTests: XCTestCase {
    private var sut: WeekViewModel!
    private var event: Event!

    override func setUp() {
        super.setUp()
        let today = DayIndex.referenceValue
        let created = DayIndex.referenceValue
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
        event.addHappening(date: DayIndex.referenceValue.date.addingTimeInterval(5))
        sut = make(
            today: DayIndex.referenceValue,
            created: DayIndex.referenceValue,
            event: event
        )

        XCTAssertEqual(sut.timeline.first??.items.count, 1)
    }

    func test_todayAfterCreation_numberOfDays_moreThan21() {
        let dateTodayMonthAfterCreation = DayIndex.referenceValue.adding(
            dateComponents: DateComponents(month: 1)
        )

        sut = make(
            today: dateTodayMonthAfterCreation,
            created: DayIndex.referenceValue,
            event: event
        )

        XCTAssertLessThan(21, sut.timeline.count)
    }

    func test_sameDates_showsOneWeek() {
        XCTAssertLessThanOrEqual(7, sut.timeline.count)
    }

    func test_sameDates_scrollToIndex_0() {
        XCTAssertEqual(sut.timelineVisibleIndex, 0)
    }

    func test_dateCreatedHasWeekdayOffset_firstCellIsMondayBeforeDateCreated() {
        for i in 1 ..< 6 {
            let created = DayIndex.referenceValue.adding(dateComponents: DateComponents(day: i))
            let sut = make(
                today: created,
                created: created,
                event: event
            )

            let firstItemDayNumber = Int(sut.timeline.first??.dayNumber ?? "1") ?? 1

            XCTAssertEqual(firstItemDayNumber, 1)
        }
    }

    func test_randomDates_scrollToIndex_isAlwaysMonday() {
        arrangeRandomDates()

        let date = sut.timeline[sut.timelineVisibleIndex]?.date
        XCTAssertEqual(WeekDay.make(date!), WeekDay.monday)
    }

    func test_randomDates_numberOfDays_multipleOf7() {
        arrangeRandomDates()

        XCTAssertEqual(sut.timeline.count % 7, 0)
    }

    private func make(
        today: DayIndex,
        created: DayIndex,
        event: Event
    ) -> WeekViewModel {
        let container = ApplicationContainer(testingInMemoryMode: true)
        let details = container.makeContainer().makeContainer(event: event, today: today)
        let week = details.makeWeekViewController()
        return week.viewModel
    }

    private func arrangeRandomDates() {
        let randomDateOfCreation = DayIndex.referenceValue.adding(
            dateComponents: DateComponents(day: Int.random(in: 0 ..< 1000))
        )

        let randomDateToday = randomDateOfCreation.adding(
            dateComponents: DateComponents(day: Int.random(in: 0 ..< 1000))
        )

        sut = make(today: randomDateToday, created: randomDateOfCreation, event: event)
    }
}
