//
//  EventsSortingContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventsSortingContainerTests: XCTestCase {
    private var sut: EventsSortingContainer!

    override func setUp() {
        super.setUp()

        let applicationContainer = ApplicationContainer(mode: .unitTest)
        let listContainer = EventsListContainer(applicationContainer)
        sut = EventsSortingContainer(provider: listContainer.sortingProvider)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init_requiresEventsSortingQuerying() { XCTAssertNotNil(sut) }

    func test_conformsToControllerFactoring() { sut is ControllerFactoring }

    func test_makeController_configuredForPresentationEventsSorting() {
        let controller = sut.make()

        XCTAssertNotNil(controller.transitioningDelegate)
        XCTAssertEqual(controller.modalPresentationStyle, .custom)
    }

    func test_makeController_isEventsSortingController() {
        let controller = sut.make()

        XCTAssertNotNil(controller as? EventsSortingController)
    }
}
