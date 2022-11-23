//
//  ClockControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.11.2022.
//

@testable import Application
import Domain
import Foundation

import XCTest

class ClockControllerTests: XCTestCase {
    private var sut: ClockController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "Event")
        sut = ClockController(event: event)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }
}
