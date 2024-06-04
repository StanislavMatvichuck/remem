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
        let sut = make(withDateCreatedAndTodayOffset: 0)

        XCTAssertEqual(sut.dayMaximum, 0)
    }

    func test_dayMaximumAmount_oneHappening_one() {
        let sut = make(withDateCreatedAndTodayOffset: 0, happenings: [DayIndex.referenceValue.date])

        XCTAssertEqual(sut.dayMaximum, 1)
    }

    func test_dayMaximumAmount_oneHappeningFiveHappenings_five() {
        let sut = make(withDateCreatedAndTodayOffset: 0, happenings: [
            DayIndex.referenceValue.adding(days: 0).date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
        ])

        XCTAssertEqual(sut.dayMaximum, 5)
    }

    func test_dayMaximumAmount_oneHappeningAtSunday_one() {
        let sut = make(withDateCreatedAndTodayOffset: 0, happenings: [DayIndex.referenceValue.adding(days: 6).date])

        XCTAssertEqual(sut.dayMaximum, 1)
    }

    private func make(withDateCreatedAndTodayOffset: Int, happenings: [Date] = []) -> WeekViewModel {
        var event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        for happening in happenings { event.addHappening(date: happening) }

        let app = ApplicationContainer(mode: .injectedCurrentMoment, currentMoment: DayIndex.referenceValue.adding(days: withDateCreatedAndTodayOffset).date)
        app.eventsStorage.create(event: event)
        let details = EventDetailsContainer(app, eventId: event.id)
        let container = WeekContainer(details)
        return container.makeWeekViewModel()
    }
}
