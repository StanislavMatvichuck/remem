//
//  NewWeekPageViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import XCTest

final class NewWeekPageViewModelTests: XCTestCase {
    func test_hasLocalisedWeekNumberDescription() { XCTAssertNotNil(NewWeekPageViewModel.weekNumberDescription.count) }
    func test_hasLocalisedTotalDescription() { XCTAssertNotNil(NewWeekPageViewModel.totalNumberDescription.count) }

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
        let sut = make()

        XCTAssertEqual(sut.totalNumber, 1)
    }

    func test_titleHasWeekNumberAndTotalNumberLocalized() {
        let sut = make()

        XCTAssertEqual(sut.title, "Week 1 total 1")
    }

    func test_localisedMonth_isFullMonthName() {
        let sut = make()

        XCTAssertEqual(sut.localisedMonth, "January")
    }

    func test_daysCount_isSeven() {
        XCTAssertEqual(NewWeekPageViewModel.daysCount, 7)
    }

    func test_weekMaximumHappenings_noHappenings_zero() {
        let sut = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.weekMaximumHappeningsCount, 0)
    }

    func test_weekMaximumHappenings_oneHappening_one() {
        let sut = make()

        XCTAssertEqual(sut.weekMaximumHappeningsCount, 1)
    }

    func test_weekMaximumHappenings_oneHappeningMondayTwoTuesday_two() {
        let sut = make(with: [
            DayIndex.referenceValue.date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
        ])

        XCTAssertEqual(sut.weekMaximumHappeningsCount, 2)
    }

    private func make(withDateCreatedAndTodayOffset offset: Int) -> NewWeekPageViewModel {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        let today = eventDayCreated.adding(days: offset)
        let container = NewWeekContainer(
            EventDetailsContainer(
                EventsListContainer(
                    ApplicationContainer(mode: .unitTest)
                ),
                event: event,
                today: today
            ),
            today: today.date
        )

        let sut = container.makeNewWeekPageViewModel(pageIndex: offset / 7)

        return sut
    }

    private func make(with happenings: [Date] = [DayIndex.referenceValue.date]) -> NewWeekPageViewModel {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        happenings.forEach { event.addHappening(date: $0) }

        let today = eventDayCreated.adding(days: 0)
        let container = NewWeekContainer(
            EventDetailsContainer(
                EventsListContainer(ApplicationContainer(mode: .unitTest)),
                event: event, today: today
            ),
            today: today.date
        )

        let sut = container.makeNewWeekPageViewModel(pageIndex: 0)

        return sut
    }
}
