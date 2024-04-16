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
    override func setUp() { super.setUp(); sut = CreateGoalViewModel(eventId: "") }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_init() { XCTAssertNotNil(sut) }
    func test_createGoalText() { XCTAssertEqual(CreateGoalViewModel.createGoal, "Create goal") }
}
