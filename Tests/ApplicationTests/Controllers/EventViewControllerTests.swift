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

        let event = Event(name: "Event")

        struct Stub: EventsCommanding {
            func save(_: Event) {}
            func delete(_: Event) {}
        }

        sut = EventViewController(
            viewModel: EventViewModel(event: event, commander: Stub()),
            controllers: [UIViewController(), UIViewController()]
        )

        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_showsTitle_nameOfEvent() {
        XCTAssertEqual(sut.title, "Event")
    }

    func test_viewDidAppear_visitEvent() {
        putInViewHierarchy(sut)

        XCTAssertFalse(sut.viewModel.isVisited, "precondition")

        sut.loadViewIfNeeded()
        executeRunLoop()

        XCTAssertTrue(sut.viewModel.isVisited)
    }

    func test_showsControllersInScroll() {
        XCTAssertLessThan(1, sut.viewRoot.scroll.viewContent.arrangedSubviews.count)
    }
}
