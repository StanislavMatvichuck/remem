//
//  EventDetailsControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

final class EventDetailsViewControllerTests: XCTestCase, EventDetailsViewControllerTesting {
    var sut: EventDetailsViewController!
    var event: Event!
    var viewModelFactory: EventViewModelFactoring!

    override func setUp() {
        super.setUp()
        makeSutWithViewModelFactory()
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        clearSutAndViewModelFactory()
        executeRunLoop()
        super.tearDown()
    }

    func test_showsTitle_nameOfEvent() {
        XCTAssertEqual(sut.title, "Event")
    }

    func test_viewDidAppear_visitEvent() {
        putInViewHierarchy(sut)

        XCTAssertFalse(sut.viewModel.isVisited, "precondition")

        executeRunLoop()

        XCTAssertTrue(sut.viewModel.isVisited)
    }

    func test_showsControllersInScroll() {
        XCTAssertLessThan(1, sut.viewRoot.scroll.viewContent.arrangedSubviews.count)
    }
}
