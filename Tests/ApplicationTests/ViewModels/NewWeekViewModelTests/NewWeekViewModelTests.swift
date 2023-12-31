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

    private func make(withDateCreatedAndTodayOffset: Int) -> NewWeekViewModel {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let today = DayIndex(event.dateCreated).adding(days: withDateCreatedAndTodayOffset)
        return
            NewWeekContainer(
                EventDetailsContainer(
                    EventsListContainer(
                        ApplicationContainer(mode: .unitTest)
                    ),
                    event: event
                ),
                today: today.date
            ).makeNewWeekViewModel()
    }
}
