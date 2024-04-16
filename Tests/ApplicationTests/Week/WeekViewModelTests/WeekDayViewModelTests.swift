//
//  WeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 20.12.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekDayViewModelTests: XCTestCase {
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
                DayIndex.referenceValue.date,
            ]
        )

        XCTAssertEqual(sut.happeningsAmount, "2")
    }

    func test_relativeLength_mon1_one() {
        let sut = make(
            for: IndexPath(row: 0, section: 0),
            withHappeningsAt: [DayIndex.referenceValue.date]
        )

        XCTAssertEqual(sut.relativeLength, 1)
    }

    func test_relativeLength_mon1_tue2_half() {
        let sut = make(
            for: IndexPath(row: 0, section: 0),
            withHappeningsAt: [
                DayIndex.referenceValue.date,
                DayIndex.referenceValue.adding(days: 1).date,
                DayIndex.referenceValue.adding(days: 1).date,
            ]
        )

        XCTAssertEqual(sut.relativeLength, 0.5)
    }

    func test_relativeLength_mon1_tue3() {
        let happenings = [
            DayIndex.referenceValue.date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
            DayIndex.referenceValue.adding(days: 1).date,
        ]

        let sutMonday = make(for: IndexPath(row: 0, section: 0), withHappeningsAt: happenings)
        let sutTuesday = make(for: IndexPath(row: 1, section: 0), withHappeningsAt: happenings)

        XCTAssertEqual(sutMonday.relativeLength, 0.333, accuracy: 0.001)
        XCTAssertEqual(sutTuesday.relativeLength, 1.0, accuracy: 0.001)
    }

    private func make(
        for index: IndexPath,
        pageIndex: Int = 0,
        withHappeningsAt: [Date] = []
    ) -> WeekDayViewModel {
        let eventDayCreated = DayIndex.referenceValue
        let event = Event(name: "", dateCreated: eventDayCreated.date)
        withHappeningsAt.forEach { event.addHappening(date: $0) }
        
        let app = ApplicationContainer(mode: .unitTest)
        app.commander.save(event)
        let details = EventDetailsContainer(app, eventId: event.id)

        let container = WeekContainer(details)

        let sut = container.makeWeekViewModel().page(at: pageIndex).day(dayNumberInWeek: index.row - pageIndex * 7)

        return sut
    }
}
