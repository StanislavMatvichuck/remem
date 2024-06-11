//
//  WeekPageViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekPageViewModelTests: XCTestCase {
    func test_hasLocalisedWeekNumberDescription() { XCTAssertNotNil(WeekPageViewModel.weekNumberDescription.count) }
    func test_hasLocalisedTotalDescription() { XCTAssertNotNil(WeekPageViewModel.totalNumberDescription.count) }

    func test_weekNumber_withEventDateCreatedAndTodaySameDay_isOne() {
        let sut = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.weekNumber, 1)
    }

    func test_weekNumber_withEventDateCreatedAndTodaySixDaysLater_isOne() {
        let sut = make(withDateCreatedAndTodayOffset: 6)

        XCTAssertEqual(sut.weekNumber, 1)
    }

    func test_weekNumber_withEventDateCreatedAndTodaySevenDaysLater_isTwo() {
        let sut = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.weekNumber, 2)
    }

    func test_weekNumber_withEventDateCreatedAndTodayTenDaysLater_isTwo() {
        let sut = make(withDateCreatedAndTodayOffset: 10)

        XCTAssertEqual(sut.weekNumber, 2)
    }

    /// May be tested in Event class
    func test_amountNumber_withEmptyEvent_isZero() {
        let sut = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.totalNumber, 0)
    }

    /// May be tested in Event class
    func test_amountNumber_withOneHappeningAtToday_isOne() {
        let sut = makeWithOneHappening()

        XCTAssertEqual(sut.totalNumber, 1)
    }

    func test_titleHasWeekNumberAndTotalNumberLocalized() {
        let sut = makeWithOneHappening()

        XCTAssertEqual(sut.title, "Week 1 total 1")
    }

    func test_localisedMonth_isFullMonthName() {
        let sut = make()

        XCTAssertEqual(sut.localisedMonth, "January")
    }

    func test_daysCount_isSeven() {
        XCTAssertEqual(WeekPageViewModel.daysCount, 7)
    }

    private func make(withDateCreatedAndTodayOffset offset: Int = 0) -> WeekPageViewModel {
        WeekContainer.makeForUnitTests().makeWeekPageViewModel(pageIndex: offset / 7, dailyMaximum: 0)
    }

    private func makeWithOneHappening() -> WeekPageViewModel {
       var event = Event.makeForUnitTests()
        event.addHappening(date: DayIndex.referenceValue.date)
        let details = EventDetailsContainer.makeForUnitTests(event: event)
        details.parent.eventsWriter.update(id: event.id, event: event)
        return WeekContainer(details).makeWeekPageViewModel(pageIndex: 0, dailyMaximum: 1)
    }
}
