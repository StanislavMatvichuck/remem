//
//  HourDistributionControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class HourDistributionControllerTests: XCTestCase {
    private var sut: HourDistributionController!
    
    override func setUp() {
        super.setUp()
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        let detailsContainer = EventDetailsContainer(appContainer, event: event)
        let container = HourDistributionContainer(detailsContainer)
        sut = HourDistributionController(container)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_view() { XCTAssertNotNil(sut.view as? HourDistributionView) }
    func test_viewModel() { XCTAssertNotNil(sut.viewModel) }
}
