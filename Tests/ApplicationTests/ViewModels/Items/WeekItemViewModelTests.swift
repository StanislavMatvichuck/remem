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
    private var sut: WeekItemViewModel!

    override func setUp() {
        super.setUp()
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)

        sut = WeekItemViewModel(
            event: event,
            day: day,
            today: day,
            coordinator: DefaultCoordinatorStub()
        )
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_empty_amountIs0() {
        XCTAssertEqual(sut.amount, "0")
    }

    func test_dayAndTodayMatches_isTodayTrue() {
        XCTAssertTrue(sut.isToday)
    }

    func test_dayAndTodayAreDifferent_isTodayFalse() {
        let day = DayComponents.referenceValue
        let dayLater = day.adding(components: DateComponents(hour: 24))
        let event = Event(name: "Event", dateCreated: day.date)
        let sut = WeekItemViewModel(
            event: event,
            day: day,
            today: dayLater,
            coordinator: ApplicationContainer().coordinator
        )

        XCTAssertFalse(sut.isToday)
    }

    func test_hasDayNumber() {
        XCTAssertEqual(sut.dayNumber, "1")
    }

    func test_oneHappening_showsHappeningTime() {
        let day = DayComponents.referenceValue
        let event = Event(name: "Event", dateCreated: day.date)
        event.addHappening(date: day.date)

        sut = WeekItemViewModel(
            event: event,
            day: day,
            today: day,
            coordinator: ApplicationContainer().coordinator
        )

        XCTAssertEqual(sut.items.first, "00:00")
    }
}
