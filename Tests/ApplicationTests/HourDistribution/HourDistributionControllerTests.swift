//
//  HourDistributionControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class HourDistributionControllerTests: XCTestCase {
    private var sut: HourDistributionController!

    override func setUp() {
        super.setUp()
        sut = HourDistributionContainer.makeForUnitTests().makeHourDistributionController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() { super.tearDown(); sut = nil }

    func test_init() { XCTAssertNotNil(sut) }
    func test_view() { XCTAssertNotNil(sut.view as? HourDistributionView) }
    func test_viewModel() { XCTAssertNotNil(sut.viewModel) }
}
