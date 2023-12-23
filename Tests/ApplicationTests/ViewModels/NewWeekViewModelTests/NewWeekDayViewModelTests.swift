//
//  NewWeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import XCTest

final class NewWeekDayViewModelTest: XCTestCase {
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

    func test_dayName_withEventDateCreatedAtReferenceDate_firstIndex_isM() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertEqual(sut.dayName, "M")
    }

    func test_dayName_withEventDateCreatedAtReferenceDate_eighthIndex_isM() {
        let sut = make(for: IndexPath(row: 0, section: 0), pageIndex: 1)

        XCTAssertEqual(sut.dayName, "M")
    }

    func test_isDimmed_withEventDateCreatedAtRererenceDateAndTodayAtReferenceDate_firstIndex_false() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertFalse(sut.isDimmed)
    }

    func test_isDimmed_withEventDateCreatedAtRererenceDateAndTodayAtReferenceDate_secondIndex_true() {
        let sut = make(for: IndexPath(row: 1, section: 0))

        XCTAssertTrue(sut.isDimmed)
    }

    func test_hasHappenings_noHappeningsAtFirstIndex_false() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertFalse(sut.hasHappenings)
    }

    func test_hasHappenings_oneHappeningAtFirstIndex_true() {
        let sut = make(
            for: IndexPath(row: 0, section: 0),
            withHappeningsAt: [DayIndex.referenceValue.date]
        )

        XCTAssertTrue(sut.hasHappenings)
    }

    func test_happeningsAmount_noHappeningsAtFirstIndex_0() {
        let sut = make(for: IndexPath(row: 0, section: 0))

        XCTAssertEqual(sut.happeningsAmount, "0")
    }

    func test_happeningsAmount_oneHappeningAtFirstIndex_1() {
        let sut = make(
            for: IndexPath(row: 0, section: 0),
            withHappeningsAt: [DayIndex.referenceValue.date]
        )

        XCTAssertEqual(sut.happeningsAmount, "1")
    }

    func test_happeningsAmount_twoHappeningsAtFirstIndex_2() {
        let sut = make(
            for: IndexPath(row: 0, section: 0),
            withHappeningsAt: [
                DayIndex.referenceValue.date,
                DayIndex.referenceValue.date
            ]
        )

        XCTAssertEqual(sut.happeningsAmount, "2")
    }

    private func make(
        for index: IndexPath,
        pageIndex: Int = 0,
        withHappeningsAt: [Date] = []
    ) -> NewWeekDayViewModel {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        withHappeningsAt.forEach { event.addHappening(date: $0) }

        let today = eventDayCreated.adding(days: 0)
        let container = NewWeekContainer(
            ApplicationContainer(mode: .unitTest)
                .makeContainer()
                .makeContainer(event: event, today: today),
            today: today.date
        )

        let sut = container.makeNewWeekDayViewModel(index: index.row, pageIndex: pageIndex)

        return sut
    }
}
