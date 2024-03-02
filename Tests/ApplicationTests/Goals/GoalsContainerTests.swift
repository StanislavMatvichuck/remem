//
//  GoalsContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class GoalsContainerTests: XCTestCase {
    private var sut: GoalsContainer!
    
    override func setUp() {
        super.setUp()
        sut = GoalsContainer(
            EventDetailsContainer(
                ApplicationContainer(mode: .unitTest),
                event: Event(
                    name: "",
                    dateCreated: DayIndex.referenceValue.date
                )
            )
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_makesController() { XCTAssertTrue(sut is ControllerFactoring) }
    func test_makesViewModel() { XCTAssertTrue(sut is GoalsViewModelFactoring) }
}
