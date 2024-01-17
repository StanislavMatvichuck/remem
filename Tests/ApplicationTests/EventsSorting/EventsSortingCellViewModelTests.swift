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
        sut = EventsSortingCellViewModel(EventsSorter.alphabetical)
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init_requiresEventsSorter() {
        XCTAssertNotNil(sut)
    }

    func test_title() {
        sut = EventsSortingCellViewModel(.alphabetical)
        XCTAssertEqual(sut.title, "By name")

        sut = EventsSortingCellViewModel(.happeningsCountTotal)
        XCTAssertEqual(sut.title, "By total")

        sut = EventsSortingCellViewModel(.manual(identifiers: []))
        XCTAssertEqual(sut.title, "Manual")
    }
}
