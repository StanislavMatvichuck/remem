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
    var sut: EventDetailsController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "EventName")
        let factory = ApplicationFactory()
        let coordinator = factory.makeCoordinator()
        let ucFake = EventEditUseCasingFake()

        sut = EventDetailsController(
            event: event,
            useCase: ucFake,
            coordinator: coordinator,
            controllers: []
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_titleIsNameOfEvent() {
        XCTAssertEqual(sut.title, "EventName")
    }

    func test_viewDidAppear_visitEvent() {
        putInViewHierarchy(sut)

        XCTAssertNil(sut.viewModel.event.dateVisited, "precondition")

        sut.loadViewIfNeeded()
        executeRunLoop()

        XCTAssertNotNil(sut.viewModel.event.dateVisited)
    }
}
