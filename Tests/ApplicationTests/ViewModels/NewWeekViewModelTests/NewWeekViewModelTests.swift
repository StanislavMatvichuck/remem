//
//  NewWeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.12.2023.
//

@testable import Application
import Domain
import XCTest

final class NewWeekViewModelTests: XCTestCase {
    func test_hasLocalisedWeekNumberDescription() { XCTAssertNotNil(NewWeekViewModel.weekNumberDescription.count) }
    func test_hasLocalisedTotalDescription() { XCTAssertNotNil(NewWeekViewModel.totalNumberDescription.count) }

    func test_weekNumber_withEventDateCreatedAndTodaySameDay_isOne() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.weekNumber(forToday: today), 1)
    }

    func test_weekNumber_withEventDateCreatedAndTodaySixDaysLater_isOne() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 6)

        XCTAssertEqual(sut.weekNumber(forToday: today), 1)
    }

    func test_weekNumber_withEventDateCreatedAndTodaySevenDaysLater_isTwo() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.weekNumber(forToday: today), 2)
    }

    func test_weekNumber_withEventDateCreatedAndTodayTenDaysLater_isTwo() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 10)

        XCTAssertEqual(sut.weekNumber(forToday: today), 2)
    }

    /// May be tested in Event class
    func test_amountNumber_withEmptyEvent_isZero() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.totalNumber(forToday: today), 0)
    }

    /// May be tested in Event class
    func test_amountNumber_withOneHappeningAtToday_isOne() {
        let (sut, today) = makeWithOneHappening()

        XCTAssertEqual(sut.totalNumber(forToday: today), 1)
    }

    func test_titleHasWeekNumberAndTotalNumberLocalized() {
        let (sut, today) = makeWithOneHappening()

        XCTAssertEqual(sut.title(forToday: today), "Week 1 total 1")
    }

    func test_localisedMonth_isFullMonthName() {
        let (sut, today) = makeWithOneHappening()

        XCTAssertEqual(sut.localisedMonth(forToday: today), "January")
    }

    func test_localisedDays_hasSevenShortNames() {
        XCTAssertEqual(NewWeekViewModel.localisedDaysNames.count, 7)
    }

    func test_cellsCount_withEventDateCreatedAndTodaySameDay_isSeven() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.cellsCount(forToday: today), 7)
    }

    func test_cellsCount_withEventDateCreatedAndTodayAfterSixDays_isSeven() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 6)

        XCTAssertEqual(sut.cellsCount(forToday: today), 7)
    }

    func test_cellsCount_withEventDateCreatedAndTodayAfterSevenDays_isFourteen() {
        let (sut, today) = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.cellsCount(forToday: today), 14)
    }

    private func make(withDateCreatedAndTodayOffset offset: Int) -> (sut: NewWeekViewModel, today: Date) {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        let today = eventDayCreated.adding(days: offset)
        let container = NewWeekContainer(
            ApplicationContainer(mode: .unitTest)
                .makeContainer()
                .makeContainer(event: event, today: today)
        )

        let sut = container.makeNewWeekViewModel()

        return (sut: sut, today: today.date)
    }

    private func makeWithOneHappening() -> (sut: NewWeekViewModel, today: Date) {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        event.addHappening(date: eventDayCreated.date.addingTimeInterval(60))
        let today = eventDayCreated.adding(days: 0)
        let container = NewWeekContainer(
            ApplicationContainer(mode: .unitTest)
                .makeContainer()
                .makeContainer(event: event, today: today)
        )

        let sut = container.makeNewWeekViewModel()

        return (sut: sut, today: today.date)
    }
}
