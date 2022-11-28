//
//  EventViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.11.2022.
//

@testable import Application
import Domain
import XCTest

class EventViewModelTests: XCTestCase {
    private var sut: EventViewModel!

    override func setUp() {
        super.setUp()

        let event = Event(name: "Event")
        let day = DayComponents(date: .now)
        sut = EventViewModel(event: event, today: day)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }
}
