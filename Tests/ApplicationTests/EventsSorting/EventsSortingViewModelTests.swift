//
//  EventsSortingViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsSortingViewModelTests: XCTestCase {
    private var sut: EventsSortingViewModel!

    override func setUp() {
        super.setUp()
        sut = EventsSortingViewModel()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_count_three() { XCTAssertEqual(sut.count, 3) }

    func test_initWithActiveSorterAlphabetical_cellAt_first_isActiveTrue() {
        sut = EventsSortingViewModel(EventsSorter.alphabetical)

        let cell = sut.cell(at: 0)

        XCTAssertTrue(cell.isActive)
    }

    func test_initWithActiveSorterAlphabetical_cellAt_second_isActiveFalse() {
        sut = EventsSortingViewModel(EventsSorter.alphabetical)

        let cell = sut.cell(at: 1)

        XCTAssertFalse(cell.isActive)
    }
}
