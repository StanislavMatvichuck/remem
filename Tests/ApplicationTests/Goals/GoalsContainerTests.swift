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
    private weak var weakSUT: GoalsContainer?
    override func setUp() {
        super.setUp()
        sut = GoalsContainer.makeForUnitTests()
        let controller = sut.makeGoalsController()
        controller.loadViewIfNeeded()
        weakSUT = sut
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
        executeRunLoop(until: .now + 0.1)
        XCTAssertNil(weakSUT)
    }

    func test_init() { XCTAssertNotNil(sut) }
    func test_makesController() { XCTAssertNotNil(sut.makeGoalsController()) }
    func test_makesViewModel() { XCTAssertTrue(sut is GoalsViewModelFactoring) }
}
