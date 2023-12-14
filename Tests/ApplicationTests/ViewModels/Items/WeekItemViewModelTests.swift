//
//  WeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekItemViewModelTests: XCTestCase {
    private var sut: WeekCellViewModel!

    override func setUp() {
        super.setUp()
        let day = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)

        sut = WeekCellViewModel(
            event: event,
            day: day,
            today: day,
            tapHandler: {}
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty_amountIs0() {
        XCTAssertEqual(sut.amount, "0")
    }

    func test_dayAndTodayMatches_isTodayTrue() {
        XCTAssertTrue(sut.isToday)
    }

    func test_dayAndTodayAreDifferent_isTodayFalse() {
        let day = DayIndex.referenceValue
        let dayLater = day.adding(dateComponents: DateComponents(hour: 24))
        let event = Event(name: "Event", dateCreated: day.date)
        let sut = WeekCellViewModel(
            event: event,
            day: day,
            today: dayLater,
            tapHandler: {}
        )

        XCTAssertFalse(sut.isToday)
    }

    func test_hasDayNumber() {
        XCTAssertEqual(sut.dayNumber, "1")
    }

    func test_oneHappening_showsHappeningTime() {
        let day = DayIndex.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        event.addHappening(date: day.date)

        sut = WeekCellViewModel(
            event: event,
            day: day,
            today: day,
            tapHandler: {}
        )

        XCTAssertEqual(sut.items.first, "00:00")
    }
}
