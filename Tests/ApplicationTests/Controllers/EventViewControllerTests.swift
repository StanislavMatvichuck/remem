//
//  EventDetailsControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

class EventViewControllerTests: XCTestCase {
    var sut: EventViewController!

    override func setUp() {
        super.setUp()
        let event = Event(name: "EventName")
        let ucFake = EventEditUseCasingFake()

        let sut = EventViewController(
            event: event,
            useCase: ucFake,
            controllers: [UIViewController(), UIViewController()]
        )

        self.sut = sut
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_showsTitle_nameOfEvent() {
        XCTAssertEqual(sut.title, "EventName")
    }

    func test_viewDidAppear_visitEvent() {
        putInViewHierarchy(sut)

        XCTAssertNil(sut.event.dateVisited, "precondition")

        sut.loadViewIfNeeded()
        executeRunLoop()

        XCTAssertNotNil(sut.event.dateVisited)
    }

    func test_showsControllersInScroll() {
        XCTAssertLessThan(1, sut.viewRoot.scroll.viewContent.arrangedSubviews.count)
    }
}
