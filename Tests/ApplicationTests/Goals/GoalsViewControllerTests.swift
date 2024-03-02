//
//  GoalsViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class GoalsViewControllerTests: XCTestCase {
    private var sut: GoalsViewController!
    
    override func setUp() {
        super.setUp()
        let container = GoalsContainer(
            EventDetailsContainer(
                ApplicationContainer(mode: .unitTest),
                event: Event(
                    name: "",
                    dateCreated: DayIndex.referenceValue.date
                )
            )
        )
        sut = container.make() as? GoalsViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_showsGoalsView() { XCTAssertTrue(sut.view is GoalsView) }
    func test_receivesUpdates() { XCTAssertTrue(sut is Updating) }
}
