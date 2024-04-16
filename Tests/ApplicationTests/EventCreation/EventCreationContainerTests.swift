//
//  EventCreationContainerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventCreationContainerTests: XCTestCase {
    var sut: EventCreationContainer!
    override func setUp() { super.setUp(); sut = EventCreationContainer.makeForUnitTests() }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_init() { XCTAssertNotNil(sut) }
    func test_makesController() { XCTAssertNotNil(sut.makeCreateEventController()) }
    func test_makesViewModel() { XCTAssertNotNil(sut.makeEventCreationViewModel()) }
}
