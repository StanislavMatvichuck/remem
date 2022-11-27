//
//  WeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.11.2022.
//

@testable import Application
import Domain
import XCTest

class WeekCellViewModelTests: XCTestCase {
    private var sut: WeekCellViewModel!

    override func setUp() {
        super.setUp()
        let day = DayComponents.referenceValue
        sut = WeekCellViewModel(day: day, today: day, happenings: [])
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
        let sut = WeekCellViewModel(day: day, today: dayLater, happenings: [])

        XCTAssertFalse(sut.isToday)
    }
}
