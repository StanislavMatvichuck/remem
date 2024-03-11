//
//  CreateGoalViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

@testable import Application
import Foundation
import XCTest

final class CreateGoalViewModelTests: XCTestCase {
    private var sut: CreateGoalViewModel!
    
    override func setUp() {
        super.setUp()
        sut = CreateGoalViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - Tests
    
    func test_init() { XCTAssertNotNil(sut) }
    func test_createGoalText() { XCTAssertEqual(CreateGoalViewModel.createGoal, "Create goal") }
    func test_init_acceptsTapHandler() { sut = CreateGoalViewModel() }
    func test_handleCreateTap() { sut.command?.execute() }
}
