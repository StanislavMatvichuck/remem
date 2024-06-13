//
//  HourDistributionContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class HourDistributionContainerTests: XCTestCase {
    private var sut: HourDistributionContainer!
    override func setUp() { super.setUp(); sut = HourDistributionContainer.makeForUnitTests() }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_init_requiresEventDetailsContainer() { XCTAssertNotNil(sut) }
    func test_makesController() { XCTAssertNotNil(sut.makeHourDistributionController()) }
    func test_makesViewModel() { XCTAssertNotNil(sut as? any LoadableHourDistributionViewModelFactoring) }
}
