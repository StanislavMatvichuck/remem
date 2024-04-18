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

final class GoalsControllerTests: XCTestCase {
    private var sut: GoalsController!
    
    override func setUp() {
        super.setUp()
        sut = GoalsContainer.makeForUnitTests().makeGoalsController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_showsGoalsView() { XCTAssertTrue(sut.view is GoalsView) }
    func test_receivesUpdates() { XCTAssertTrue(sut is Updating) }
}
