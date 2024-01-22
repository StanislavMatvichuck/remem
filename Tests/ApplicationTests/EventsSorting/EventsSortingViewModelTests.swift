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
        let applicationContainer = ApplicationContainer(mode: .unitTest)
        let listContainer = EventsListContainer(applicationContainer)
        let container = EventsSortingContainer(
            provider: listContainer.sortingProvider,
            commander: listContainer.sortingCommander,
            updater: listContainer.updater
        )
        sut = container.makeEventsSortingViewModel()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_count_two() { XCTAssertEqual(sut.count, 2) }

    func test_initWithActiveSorterName_cellAt_first_isActiveTrue() {
        let cell = sut.cell(at: 0)

        XCTAssertTrue(cell.isActive)
    }

    func test_initWithActiveSorterName_cellAt_second_isActiveFalse() {
        let cell = sut.cell(at: 1)

        XCTAssertFalse(cell.isActive)
    }

    func test_manualSortingEnabled_false() {
        XCTAssertFalse(sut.manualSortingEnabled)
    }

    func test_count_manualSortingEnabled_three() {
        sut = EventsSortingViewModel(EventsSortingCellFactoryStub(), manualSortingEnabled: true)

        XCTAssertEqual(sut.count, 3)
    }
}

struct EventsSortingCellFactoryStub: EventsSortingCellViewModelFactoring {
    func makeEventsSortingCellViewModel(index: Int) -> EventsSortingCellViewModel {
        EventsSortingCellViewModel(.name)
    }
}
