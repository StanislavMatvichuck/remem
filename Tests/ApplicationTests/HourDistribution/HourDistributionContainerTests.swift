//
//  HourDistributionContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class HourDistributionContainerTests: XCTestCase {
    private var sut: HourDistributionContainer!
    
    override func setUp() {
        super.setUp()
        let event = Event(name: "", dateCreated: DayIndex.referenceValue.date)
        let appContainer = ApplicationContainer(mode: .unitTest)
        let container = EventDetailsContainer(appContainer, event: event)
        sut = HourDistributionContainer(container)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init_requiresEventDetailsContainer() { XCTAssertNotNil(sut) }
    func test_makesController() {
        XCTAssertNotNil(sut.make() as? HourDistributionController)
    }
}
