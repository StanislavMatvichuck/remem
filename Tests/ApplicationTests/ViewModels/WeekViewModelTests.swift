//
//  WeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekViewModelTests: XCTestCase {
    private var sut: WeekViewModel!

    override func setUp() {
        super.setUp()

        sut = WeekViewModel(
            today: DayComponents.referenceValue,
            event: Event(name: "Event")
        )
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_eventWithHappeningOnFirstDay_addsHappeningToFirstCell() {
        let dateCreated = DayComponents.referenceValue.date
        let event = Event(name: "Event", dateCreated: dateCreated)
        event.addHappening(date: dateCreated.addingTimeInterval(5))

        sut = WeekViewModel(today: DayComponents.referenceValue, event: event)

        XCTAssertEqual(sut.weekCellViewModels.first?.happenings.count, 1)
    }
}
