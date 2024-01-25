//
//  DayOfWeekCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.01.2024.
//

@testable import Application
import XCTest

final class DayOfWeekCellViewModelTests: XCTestCase {
    var sut: DayOfWeekCellViewModel!

    override func setUp() {
        super.setUp()
        sut = DayOfWeekCellViewModel(0)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_init_requiresIndex() { _ = DayOfWeekCellViewModel(0) }

    func test_shortDayName() {
        XCTAssertEqual(sut.shortDayName, "M")

        sut = DayOfWeekCellViewModel(1)
        XCTAssertEqual(sut.shortDayName, "T")

        sut = DayOfWeekCellViewModel(2)
        XCTAssertEqual(sut.shortDayName, "W")

        sut = DayOfWeekCellViewModel(3)
        XCTAssertEqual(sut.shortDayName, "T")

        sut = DayOfWeekCellViewModel(4)
        XCTAssertEqual(sut.shortDayName, "F")

        sut = DayOfWeekCellViewModel(5)
        XCTAssertEqual(sut.shortDayName, "S")

        sut = DayOfWeekCellViewModel(6)
        XCTAssertEqual(sut.shortDayName, "S")
    }

    func test_percentage_zero() { XCTAssertEqual(sut.percent, "0") }
    func test_value_zero() { XCTAssertEqual(sut.value, "0") }
    func test_isHidden_true() { XCTAssertTrue(sut.isHidden) }

    func test_initValueOne_isHidden_false() {
        sut = DayOfWeekCellViewModel(0, value: 1, valueTotal: 1)

        XCTAssertFalse(sut.isHidden)
    }

    func test_initValueOneValueTotalTwo_percentage_one() {
        sut = DayOfWeekCellViewModel(0, value: 1, valueTotal: 1)

        XCTAssertEqual(sut.percent, "100%")
    }

    func test_initValueOneValueTotalTwo_percentage_half() {
        sut = DayOfWeekCellViewModel(0, value: 1, valueTotal: 2)

        XCTAssertEqual(sut.percent, "50%")
    }
}
