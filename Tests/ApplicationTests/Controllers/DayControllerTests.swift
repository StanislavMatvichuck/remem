//
//  DayControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

class DayControllerTests: XCTestCase {
    var sut: DayController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "EventName")
        let useCase = EventEditUseCasingFake()
        let sut = DayController(date: .now, event: event, useCase: useCase)
        self.sut = sut
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_empty() {
        XCTAssertLessThan(3, sut.title?.count ?? 0)
    }
}
