//
//  NewWeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import XCTest

final class NewWeekCellViewModelTest: XCTestCase {
    func test_dayNumber_withEventDateCreatedAtReferenceDate_firstIndex_isOne() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertEqual(sut.dayNumber, "1")
    }

    func test_dayNumber_withEventDateCreatedAtReferenceDate_secondIndex_isTwo() {
        let sut = make(for: IndexPath(row: 1, section: 0))

        XCTAssertEqual(sut.dayNumber, "2")
    }

    func test_isToday_widthEventDateCreatedAndTodayAtReferenceDay_firstIndex_true() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertTrue(sut.isToday)
    }

    private func make(for index: IndexPath) -> NewWeekCellViewModel {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        let today = eventDayCreated.adding(days: 0)
        let container = NewWeekContainer(
            ApplicationContainer(mode: .unitTest)
                .makeContainer()
                .makeContainer(event: event, today: today)
        )

        let sut = container.makeNewWeekCellViewModel(index: index.row)

        return sut
    }
}
