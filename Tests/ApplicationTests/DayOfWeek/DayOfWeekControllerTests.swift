//
//  DayOfWeekControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class DayOfWeekControllerTests: XCTestCase {
    var sut: DayOfWeekController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        let detailsContainer = EventDetailsContainer(appContainer, event: event)
        let container = DayOfWeekContainer(detailsContainer)
        sut = DayOfWeekController(container)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_init_requiresViewModelFactory() { XCTAssertNotNil(sut) }
    func test_showsDayOfWeekView() { XCTAssertNotNil(sut.view as? DayOfWeekView) }
    func test_configuresViewModel() { XCTAssertNotNil(sut.viewModel) }
}
