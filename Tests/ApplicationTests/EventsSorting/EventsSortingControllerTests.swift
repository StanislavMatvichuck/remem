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
        sut = EventsSortingController()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() { XCTAssertNotNil(sut) }
    func test_showsEventsSortingView() { XCTAssertNotNil(sut.view as? EventsSortingView) }
}
