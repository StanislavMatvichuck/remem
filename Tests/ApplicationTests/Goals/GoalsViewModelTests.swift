//
//  GoalsViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

@testable import Application
import Foundation
import XCTest

final class GoalsViewModelTests: XCTestCase {
    private var sut: GoalsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = GoalsViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_createGoalText() { XCTAssertEqual(GoalsViewModel.createGoal, "Create goal") }
    func test_init_acceptsCreateGoalButtonTapHandler() {
        sut = GoalsViewModel(createGoalTapHandler: {})
    }
    
    func test_handleCreateTap() { sut.handleCreateTap() }
}
