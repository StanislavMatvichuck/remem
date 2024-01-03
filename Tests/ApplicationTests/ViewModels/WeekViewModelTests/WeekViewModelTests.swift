//
//  WeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.12.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekViewModelTests: XCTestCase {
    func test_pagesCount_withEventDateCreatedAndTodaySameDay_isOne() {
        let sut = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.pagesCount, 1)
    }

    func test_pagesCount_withEventDateCreatedAndTodayAfterSixDays_isOne() {
        let sut = make(withDateCreatedAndTodayOffset: 6)

        XCTAssertEqual(sut.pagesCount, 1)
    }

    func test_pagesCount_withEventDateCreatedAndTodayAfterSevenDays_isTwo() {
        let sut = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.pagesCount, 2)
    }

    func test_pagesCount_withEventDateCreatedAndTodayAfterTwentyTwoDays_isFour() {
        let sut = make(withDateCreatedAndTodayOffset: 22)

        XCTAssertEqual(sut.pagesCount, 4)
    }

    func test_pageAt_withEventDateCreatedAndTodayAfterSevenDays_firstIndex_weekNumber_isOne() {
        let sut = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.page(at: 0).weekNumber, 1)
    }

    func test_pageAt_withEventDateCreatedAndTodayAfterSevenDays_secondIndex_weekNumber_isTwo() {
        let sut = make(withDateCreatedAndTodayOffset: 7)

        XCTAssertEqual(sut.page(at: 1).weekNumber, 2)
    }

    func test_pageAt_withEventDateCreatedAndTodayAfterTwentyDays_thirdIndex_weekNumber_isThree() {
        let sut = make(withDateCreatedAndTodayOffset: 20)

        XCTAssertEqual(sut.page(at: 2).weekNumber, 3)
    }

    func test_dayMaximumAmount_noHappenings_zero() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let sut = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)).makeWeekViewModel()

        XCTAssertEqual(sut.dayMaximum, 0)
    }

    func test_dayMaximumAmount_oneHappening_one() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        event.addHappening(date: DayIndex.referenceValue.date)
        let sut = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)).makeWeekViewModel()

        XCTAssertEqual(sut.dayMaximum, 1)
    }

    func test_dayMaximumAmount_oneHappeningFiveHappenings_five() {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        for happeningIndex in [
            DayIndex.referenceValue.adding(days: 0),
            DayIndex.referenceValue.adding(days: 1),
            DayIndex.referenceValue.adding(days: 1),
            DayIndex.referenceValue.adding(days: 1),
            DayIndex.referenceValue.adding(days: 1),
            DayIndex.referenceValue.adding(days: 1),
        ] {
            event.addHappening(date: happeningIndex.date)
        }

        let sut = WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)).makeWeekViewModel()

        XCTAssertEqual(sut.dayMaximum, 5)
    }

    private func make(withHappeningsAt dates: [Date]) -> WeekViewModel {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)

        for date in dates { event.addHappening(date: date) }

        return WeekContainer(EventDetailsContainer(ApplicationContainer(mode: .unitTest), event: event)).makeWeekViewModel()
    }

    private func make(withDateCreatedAndTodayOffset: Int) -> WeekViewModel {
        WeekContainer(EventDetailsContainer(ApplicationContainer(
                mode: .injectedCurrentMoment,
                currentMoment: DayIndex.referenceValue.adding(days: withDateCreatedAndTodayOffset).date),
            event: Event(name: "", dateCreated: DayIndex.referenceValue.date))
        ).makeWeekViewModel()
    }
}
