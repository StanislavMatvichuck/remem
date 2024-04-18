//
//  EventDetailsControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 21.11.2022.
//

@testable import Application
import Domain
import XCTest

final class EventDetailsControllerTests: XCTestCase {
    var sut: EventDetailsController!
    override func setUp() {
        super.setUp()
        sut = EventDetailsContainer.makeForUnitTests().makeEventDetailsController()
        sut.loadViewIfNeeded()
    }
    override func tearDown() { super.tearDown(); sut = nil }

    func test_showsTitle_nameOfEvent() { XCTAssertEqual(sut.title, "") }

    func test_viewDidAppear_visitEvent() {
        putInViewHierarchy(sut)

        XCTAssertFalse(sut.viewModel.isVisited, "precondition")

        RunLoop.current.run(until: Date().addingTimeInterval(0.1))

        XCTAssertTrue(sut.viewModel.isVisited)
    }

    func test_showsControllersInScroll() { XCTAssertLessThan(1, sut.viewRoot.scroll.viewContent.arrangedSubviews.count) }
    func test_showsWeek() { XCTAssertEqual(sut.children.filter { $0 is WeekController }.count, 1) }
    func test_showsClock() { XCTAssertEqual(sut.children.filter { $0 is HourDistributionController }.count, 1) }
    func test_showsSummary() { XCTAssertEqual(sut.children.filter { $0 is SummaryController }.count, 1) }
    func test_showsPDFWritingView() { XCTAssertEqual(sut.children.filter { $0 is PDFWritingController }.count, 1) }
}
