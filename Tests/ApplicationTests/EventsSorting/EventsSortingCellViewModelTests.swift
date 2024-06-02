//
//  EventsSortingCellViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsSortingCellViewModelTests: XCTestCase {
    private var sut: EventsSortingCellViewModel!

    override func setUp() {
        super.setUp()
        sut = EventsSortingCellViewModel(Ordering.name)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init_requiresEventsSorter() {
        XCTAssertNotNil(sut)
    }

    func test_initWithActiveSorter_isActive_matches_true() {
        sut = EventsSortingCellViewModel(.name, activeSorter: .name)

        XCTAssertTrue(sut.isActive)
    }

    func test_initWithActiveSorter_isActive_doesNotMatch_false() {
        sut = EventsSortingCellViewModel(.name, activeSorter: .manual)

        XCTAssertFalse(sut.isActive)
    }

    func test_title() {
        sut = EventsSortingCellViewModel(.name)
        XCTAssertEqual(sut.title, "By name")

        sut = EventsSortingCellViewModel(.total)
        XCTAssertEqual(sut.title, "By total")

        sut = EventsSortingCellViewModel(.manual)
        XCTAssertEqual(sut.title, "Manual")
    }
}
