//
//  DayOfWeekContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import XCTest

final class DayOfWeekContainerTests: XCTestCase {
    private var sut: DayOfWeekContainer!
    override func setUp() { super.setUp(); sut = DayOfWeekContainer.makeForUnitTests() }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_init() { XCTAssertNotNil(sut) }
    func test_createsDayOfWeekController() { XCTAssertNotNil(sut.makeDayOfWeekController()) }
    func test_createsDayOfWeekViewModel() { XCTAssertNotNil(sut.makeDayOfWeekViewModel()) }
}
