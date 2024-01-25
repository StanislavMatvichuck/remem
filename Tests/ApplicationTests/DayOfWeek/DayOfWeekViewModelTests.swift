//
//  DayOfWeekViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 24.01.2024.
//

@testable import Application
import Domain
import XCTest

final class DayOfWeekViewModelTests: XCTestCase {
    func test_init() {
        let sut = DayOfWeekViewModel()
    }

    func test_count_seven() {
        let sut = DayOfWeekViewModel()

        XCTAssertEqual(sut.count, 7)
    }

    func test_cellAtIndex_first() {
        let sut = DayOfWeekViewModel()

        XCTAssertNotNil(sut.cell(at: 0))
    }

    func test_init_withHappenings_maximumAmount() {
        let happenings = [
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
            Happening(dateCreated: DayIndex.referenceValue.date),
        ]

        let sut = DayOfWeekViewModel(happenings)

        XCTAssertEqual(sut.valueTotal, happenings.count)
    }
}
