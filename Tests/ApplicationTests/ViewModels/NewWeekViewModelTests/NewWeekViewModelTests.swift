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

    private func make(withDateCreatedAndTodayOffset: Int) -> NewWeekViewModel {
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let today = DayIndex(event.dateCreated).adding(days: withDateCreatedAndTodayOffset)
        return
            NewWeekContainer(
                EventDetailsContainer(
                    parent: EventsListContainer(
                        parent: ApplicationContainer(
                            mode: .unitTest
                        )
                    ),
                    event: event,
                    today: today
                ),
                today: today.date
            ).makeNewWeekViewModel()
    }
}
