//
//  DayOfWeekContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import XCTest

final class DayOfWeekContainerTests: XCTestCase {
    private var sut: DayOfWeekContainer!
    
    override func setUp() {
        super.setUp()
        let appContainer = ApplicationContainer(mode: .unitTest)
        let event = Event(name: "")
        let container = EventDetailsContainer(appContainer, event: event)
        sut = DayOfWeekContainer(container)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Tests
    
    func test_init_requiresEventDetailsContainer() { XCTAssertNotNil(sut) }
    
    func test_createsDayOfWeekController() {
        XCTAssertNotNil(sut.make() as? DayOfWeekController)
    }
    
    func test_createsDayOfWeekViewModel() {
        XCTAssertNotNil(sut.makeDayOfWeekViewModel())
    }
}
