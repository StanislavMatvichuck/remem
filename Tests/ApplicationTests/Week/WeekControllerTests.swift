//
//  WeekViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

@testable import Application
import Domain
import XCTest

final class WeekControllerTests: XCTestCase {
    var sut: WeekController!
    override func setUp() { super.setUp()
        sut = WeekContainer.makeForUnitTests().makeWeekController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() { super.tearDown(); sut = nil }

    func test_showsWeekView() { XCTAssertTrue(sut.view is WeekView) }
    func test_configuresCollection() { XCTAssertNotNil(sut.viewRoot.collection.delegate) }
    func test_configuresViewModel() { XCTAssertNotNil(sut.viewRoot.viewModel) }
    func test_scrollsToLastPage() {} // todo
}
