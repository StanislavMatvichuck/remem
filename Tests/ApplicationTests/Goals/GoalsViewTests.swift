//
//  GoalsViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

@testable import Application
import Foundation
import XCTest

final class GoalsViewTests: XCTestCase {
    private var sut: GoalsView!
    
    override func setUp() {
        super.setUp()
        sut = GoalsView()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_showsCreateGoalButton() {
        XCTAssertEqual(sut.buttonCreateGoal.titleLabel?.text, "Create goal")
    }
}
