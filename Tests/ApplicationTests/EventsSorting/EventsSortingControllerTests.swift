//
//  EventsSortingControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

@testable import Application
import XCTest

final class EventsSortingControllerTests: XCTestCase {
    private var sut: EventsSortingController!

    override func setUp() {
        super.setUp()
        let applicationContainer = ApplicationContainer(mode: .unitTest)
        let listContainer = EventsListContainer(applicationContainer)
        let container = EventsSortingContainer(listContainer.sortingProvider)
        sut = EventsSortingController(container)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_requiresFactory() { XCTAssertNotNil(sut) }
    func test_showsEventsSortingView() { XCTAssertNotNil(sut.view as? EventsSortingView) }
    func test_configuresContent() {
        XCTAssertNotNil((sut.view as? EventsSortingView)?.viewModel)
    }
}
