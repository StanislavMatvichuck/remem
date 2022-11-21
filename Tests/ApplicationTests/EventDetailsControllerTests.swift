//
//  EventDetailsControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

class EventDetailsControllerTests: XCTestCase {
    func test_titleIsNameOfEvent() {
        let event = Event(name: "EventName")
        let sut = ApplicationFactory().makeEventDetailsController(event: event)

        XCTAssertEqual(sut.title, "EventName")
    }
}
