//
//  EventsListContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 19.01.2024.
//

@testable import Application
import Domain
import XCTest

final class EventsListContainerTests: XCTestCase {
    private var sut: EventsListContainer!

    override func setUp() {
        super.setUp()
        let applicationContainer = ApplicationContainer(mode: .unitTest)
        sut = EventsListContainer(applicationContainer)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_requiresApplicationContainer() { XCTAssertNotNil(sut) }

    func test_storesEventsSortingQuerying() { sut.sortingProvider is EventsSortingQuerying }
    func test_storesEventsSortingCommanding() { sut.sortingCommander is EventsSortingCommanding }
}
