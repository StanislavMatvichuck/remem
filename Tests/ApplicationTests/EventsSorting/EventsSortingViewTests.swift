//
//  EventsSortingViewTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventsSortingViewTests: XCTestCase {
    private var sut: EventsSortingView!

    override func setUp() {
        super.setUp()
        let viewModel = EventsSortingViewModel()
        sut = EventsSortingView()
        sut.viewModel = viewModel
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_displaysThreeCellsAndSpacer() {
        XCTAssertEqual(sut.stack.arrangedSubviews.count, 4)
    }
}
