//
//  DayOfWeekControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

@testable import Application
import Domain
import Foundation
import XCTest

final class DayOfWeekControllerTests: XCTestCase {
    var sut: DayOfWeekController!

    override func setUp() {
        super.setUp()
        sut = DayOfWeekContainer.makeForUnitTests().makeDayOfWeekController()
        sut.loadViewIfNeeded()
    }

    override func tearDown() { super.tearDown(); sut = nil }

    func test_init_requiresViewModelFactory() { XCTAssertNotNil(sut) }
    func test_showsDayOfWeekView() { XCTAssertNotNil(sut.view as? DayOfWeekView) }
    func test_configuresViewModel() { XCTAssertNotNil(sut.viewModel) }
}
