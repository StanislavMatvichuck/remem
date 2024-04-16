//
//  EventsSortingControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

@testable import Application
import DataLayer
import XCTest

final class EventsSortingControllerTests: XCTestCase {
    private var sut: EventsSortingController!

    override func setUp() {
        super.setUp()
        sut = EventsSortingContainer.makeForUnitTests().makeEventsOrderingController(using: ShowEventsOrderingServiceArgument(offset: 0.0, oldValue: nil))
        sut.loadViewIfNeeded()
    }

    override func tearDown() { super.tearDown(); sut = nil }

    func test_init_requiresFactory() { XCTAssertNotNil(sut) }
    func test_showsEventsSortingView() { XCTAssertNotNil(sut.view as? EventsSortingView) }
    func test_configuresContent() {
        XCTAssertNotNil((sut.view as? EventsSortingView)?.viewModel)
    }

    func test_updatable() { XCTAssertNotNil(sut as? Updating) }
}
